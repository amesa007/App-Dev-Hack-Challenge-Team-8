import sqlite3
import re
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

association_table = db.Table(
    "user_group_association",
    db.Model.metadata,
    db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
    db.Column("group_id", db.Integer, db.ForeignKey("groups.id")),
)

post_tag_association = db.Table(
    "post_tag_association", 
    db.Model.metadata,
    db.Column("post_id", db.Integer, db.ForeignKey("posts.id")),
    db.Column("tag_id", db.Integer, db.ForeignKey("tags.id")),
)

def get_tags(tag):
    return re.findall(r"#(\w+)", tag)


# your classes here
class User(db.Model):
    """
    User model
    one-to-many relationship with posts
    many-to-many relationshup with groups model
    """
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key = True, autoincrement= True)
    name = db.Column(db.String, nullable = False)

    posts = db.relationship("Post", back_populates = "user", cascade = "delete")
    groups = db.relationship("Group", secondary = association_table, back_populates = "members")

    def __init__(self, **kwargs):
        """
        Initialize user object/entry
        """
        self.name = kwargs.get("name", "")

    def serialize(self):
        """
        Serialize an user object
        """
        return {
            "id": self.id,
            "name": self.name,
            "groups": [g.simple_serialize() for g in self.groups],
            "posts": [p.simple_serialize() for p in self.posts]
        }
    
    def simple_serialize(self):
        return {
            "id": self.id,
            "name" : self.name
        }
    
class Group(db.Model):
    """
    Group model.
    """
    __tablename__ ="groups"

    id = db.Column(db.Integer, primary_key = True, autoincrement= True)
    title = db.Column(db.String, nullable = False)
    description = db.Column(db.String, nullable = False)
    
    members = db.relationship("User", secondary=association_table, back_populates = "groups")
    posts = db.relationship("Post", back_populates = "group", cascade = "delete")

    def __init__(self, **kwargs):
        """
        Initialize Group object
        """
        self.title = kwargs.get("title", "")
        self.description = kwargs.get("description", "")

    def serialize(self):
        """
        Serialize a Group object
        """
        return {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "members": [m.simple_serialize() for m in self.members],
            "posts": [p.simple_serialize() for p in self.posts]

        }
    
    def simple_serialize(self):
        return{
            "id": self.id,
            "title": self.title,
        }
    
class Post(db.Model):
    '''
    Post model
    ''' 
    __tablename__ = "posts"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    content = db.Column(db.String, nullable = False)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    group_id = db.Column(db.Integer, db.ForeignKey("groups.id"), nullable = False)
    
    user = db.relationship("User", back_populates = "posts")
    group = db.relationship("Group", back_populates = "posts")
    tags = db.relationship("Tag", secondary = post_tag_association, back_populates = "posts")

    def __init__(self, **kwargs):
        '''
        Initialize a Post object
        '''
        self.content = kwargs.get("content", "")
        self.user_id = kwargs.get("user_id", "")
        self.group_id = kwargs.get("group_id", "")

    def serialize(self):
        '''
        Serialize a Post object
        '''
        user = User.query.filter_by(id=self.user_id).first()
        return {
            "id": self.id,
            "content": self.content,
            "user": self.user.simple_serialize(),
            "group": self.group.simple_serialize(),
            "tags": [t.simple_serialize() for t in self.tags]
        }
    
    def simple_serialize(self):
        '''
        Serialize a Post object
        '''
        return {
            "id": self.id,
            "content": self.content,
        }

class Tag(db.Model):
    __tablename__="tags"

    id = db.Column(db.Integer, primary_key = True, autoincrement= True)
    name = db.Column(db.String, unique = True, nullable = False)

    group_id = db.Column(db.Integer, db.ForeignKey("groups.id"))
    group = db.relationship("Group")

    posts = db.relationship("Post", secondary = post_tag_association, back_populates = "tags")
    
    def __init__(self, **kwargs):
        self.name = kwargs.get("name", "")

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "posts": [p.simple_serialize() for p in self.posts]
        }
    
    def simple_serialize(self):
        return {
            "id": self.id,
            "name": self.name
        }