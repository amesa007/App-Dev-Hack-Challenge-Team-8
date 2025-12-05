import os

from db import db, User, Group, Post, Tag, get_tags
import json
from flask import Flask, request

app = Flask(__name__)
db_filename = "study_app.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

# Initialize the database
db.init_app(app)
with app.app_context():
    db.create_all()


#failure response
def failure_response(description, status_code=404):
    return json.dumps({"error": description}), status_code

#success response
def success_response(content, status_code=200):
    return json.dumps(content), status_code

#---------User routes------------------
@app.route("/")
def home():
    return "Study Group API"

@app.route("/api/users/", methods = ["GET"])
def get_users():
    '''
    Endpoint for getting all users
    '''
    return success_response({"users": [u.serialize() for u in User.query.all()]})

@app.route("/api/users/", methods = ["POST"])
def create_user():
    '''
    Endpoint for creating an user
    '''
    body = json.loads(request.data)
    name = body.get("name")

    if not name:
        return failure_response("Missing name")
    new_user = User(name=name)
    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.serialize(), 201)

@app.route("/api/users/<int:user_id>/", methods = ["GET"])
def get_user_by_id(user_id):
    '''
    Endpoint for getting a user id
    '''
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found!")
    return success_response(user.serialize())


@app.route("/api/users/<int:user_id>/", methods =["DELETE"])
def delete_user(user_id):
    '''
    Endpoint to delete an user
    '''
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found")
    db.session.delete(user)
    db.session.commit()
    return success_response(user.serialize())

#-------------Group routes---------------------------
@app.route("/api/groups/", methods = ["GET"])
def get_groups():
    groups = Group.query.all()
    return success_response({"groups": [g.serialize() for g in groups]})

@app.route("/api/groups/", methods = ["POST"])
def create_group():
    '''
    Endpoint for creating a group
    '''
    body = json.loads(request.data)
    title = body.get("title")
    description = body.get("description")
    if not title or not description:
        return failure_response("Missing title or description", 400)
    new_group = Group(title=title, description=description)
    db.session.add(new_group)
    db.session.commit()
    return success_response(new_group.serialize(), 201)


@app.route("/api/groups/<int:group_id>/join/", methods=["POST"])
def join_group(group_id):
    """
    Add a user to a group
    """
    group = Group.query.filter_by(id=group_id).first()
    if group is None:
        return failure_response("Group not found")
    
    body = json.loads(request.data)
    user_id = body.get("user_id")

    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found")

    group.members.append(user)
    db.session.commit()
    return success_response(group.serialize())

@app.route("/api/groups/<int:group_id>/", methods = ["DELETE"])
def delete_group(group_id):
    group = Group.query.filter_by(id=group_id).first()
    if not group:
        return failure_response("Group not found")
    db.session.delete(group)
    db.session.commit()
    return success_response(group.serialize())


#---------------- Post routes -----------------------------

@app.route("/api/posts/", methods=["POST"])
def create_post():
    """
    Create a post 
    """
    
    body = json.loads(request.data)
    user_id = body.get("user_id")
    group_id = body.get("group_id")
    content = body.get("content")

    if not user_id or group_id is None:
        return failure_response("Missing user or group id")
    
    user = User.query.filter_by(id=user_id).first()
    group = Group.query.filter_by(id=group_id).first()

    if not user or not group:
        return failure_response("User or Group not found")
    
    post = Post(
        content = content,
        user_id = user_id,
        group_id = group_id
    )

    db.session.add(post)

    tag_name =get_tags(content)
    
    for name in tag_name:
        tag = Tag.query.filter_by(name=name).first()
        if not tag:
            tag = Tag(name=name)
            db.session.add(tag)
        if tag.group_id is None:
            tag.group_id = group_id
        post.tags.append(tag)

    db.session.commit()
    return success_response(post.serialize(), 201)


@app.route("/api/groups/<int:group_id>/posts/", methods=["GET"])
def get_posts_group(group_id):
    group = Group.query.filter_by(id=group_id).first()
    if not group:
        return failure_response("Group not found")
    return success_response({"posts": [p.serialize() for p in group.posts]})

@app.route("/api/posts/<int:post_id>/", methods = ["DELETE"])
def delete_post(post_id):
    post = Post.query.filter_by(id=post_id).first()
    if not post:
        return failure_response("Post not found")
    db.session.delete(post)
    db.session.commit()
    return success_response(post.serialize())

#------------- Tag routes -----------------------------------
@app.route("/api/tags/<string:tag_name>/posts/", methods = ["GET"])
def get_post_by_tag(tag_name):
    "Get the post for the tag/class you want"
    tag = Tag.query.filter_by(name = tag_name).first()
    if not tag:
        return failure_response("Tag not found", 404)
    return success_response({"posts": [p.serialize() for p in tag.posts]})

@app.route("/api/tags/<string:tag_name>/join/", methods = ["POST"])
def join_group_by_tag(tag_name):
    body = json.loads(request.data)
    user_id = body.get("user_id")

    if user_id is None:
        return failure_response("Missing user id")
    
    user = User.query.filter_by(id=user_id).first()
    if not user:
        return failure_response("User not found")
    
    tag = Tag.query.filter_by(name=tag_name).first()
    if not tag:
        return failure_response("Tag not found")
    
    group = tag.group
    if not group:
        return failure_response("Group not found")
    
    if user not in group.members:
        group.members.append(user)
        db.session.commit()
    
    return success_response({
        "announcement": f"User joined group {group.title}",
        "group": group.serialize()
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)