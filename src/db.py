import sqlite3
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

association_table = db.Table(
    "user_group_association",
    db.Model.metadata,
    db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
    db.Column("group_id", db.Integer, db.ForeignKey("groups.id")),
)

#student_association = db.Table(
   # "student_course_association",
  #  db.Model.metadata,
   # db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
   # db.Column("course_id", db.Integer, db.ForeignKey("courses.id"))
#)


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
        Serialize a course object
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
            # "code": self.code,
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
        User = User.query.filter_by(id=self.course_id).first()
        return {
            "id": self.id,
            "content": self.content,
            "user": self.user.simple_serialize(),
            "group": self.group.simple_serialize()
        }
    
    def simple_serialize(self):
        '''
        Serialize a Post object
        '''
        return {
            "id": self.id,
            "content": self.content,
        }