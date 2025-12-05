Api Specification: 

Get all users
GET /api/users/

Response
<HTTP STATUS CODE 200>
{
  "users" : [
    {
      "id" : 1,
      "name" : "Danny",
      "groups" : [SERIALIZED GROUPS],
      "posts" : [SERIALIZED POSTS]
    }
  ]
}

Create a user
POST /api/users/

Request
{
"name" : "Danny"
}

Response
<HTTP STATUS CODE 201>
{
"id" : <ID>,
"name" : "Danny",
"groups" : [],
"posts" : []
}

Get a specific user
GET /api/users/{id}/

Response
<HTTP STATUS CODE 200>
{
"id" : <ID>,
"name" : <STORED NAME FOR USER WITH ID {id}>,
"groups" : [SERIALIZED GROUPS],
"posts" : [SERIALIZED POSTS]
}

Delete a specific user
DELETE /api/users/{id}/

Response
<HTTP STATUS CODE 200>
{
"id" : <ID>,
"name" : <STORED NAME FOR USER WITH ID {id}>,
"groups" : [SERIALIZED GROUPS],
"posts" : [SERIALIZED POSTS]
}

Get all groups
GET /api/groups/

Response
<HTTP STATUS CODE 200>
{
    "groups": [
        {
            "id": 1,
            "title": "CS 2110",
            "description": "Course group for CS 2110",
            "members": [SERIALIZED USERS],
            "posts": [SERIALIZED POSTS]
        }
    ]
}

Create a group
POST /api/group/

Request
{
    "title" : "CS 2110",
    "description" : "Course group for CS 2110"
}

Response
<HTTP STATUS CODE 201>
{
    "id": <ID>,
    "title": "CS 2110",
    "description": "Course group for CS 2110",
    "members": [],
    "posts": []
}

Join a specific group
POST /api/groups/{id}/join/

Request
{
    "user_id" : <ID>
}

Response
<HTTP STATUS CODE 200>
{
    "id": <ID>,
    "title": <STORED TITLE FOR GROUP WITH ID {id}>,
    "description": <STORED DESCRIPTION FOR GROUP WITH ID {id}>,
    "members": [
        {
            "id": 1,
            "name": "<STORED NAME FOR USER WITH ID {id>"
        }
    ],
    "posts": [SERIALIZED POSTS]
}

Delete a specific group
DELETE /api/groups/{id}/

Response
<HTTP STATUS CODE 200>
{
"id" : <ID>,
"title" : <STORED TITLE FOR GROUP WITH ID {id}>,
"description" : <STORED DESCRIPTION FOR GROUP WITH ID {id}>,
"members" : [SERIALIZED MEMBERS],
"posts" : [SERIALIZED POSTS]
}

Create a post
POST /api/posts/

Request
{
    "user_id" : <ID>,
    "group_id" : <ID>,
    "content" : "Hello everyone!"
}

Response
<HTTP STATUS CODE 201>
{
    "id": <ID>,
    "content": "Hello everyone!",
    "user": {
        "id": <USER ID>,
        "name": <STORED NAME FOR USER WITH ID {user_id}>
    },
    "group": {
        "id": <GROUP ID>,
        "title": <STORED TITLE FOR GROUP WITH ID {group_id}>
    }
}

Get all posts from a specific group
GET /api/groups/{id}/posts/
Response
<HTTP STATUS CODE 200>
{
    "post": [
        {
            "id": 1,
            "content": "Hello everyone!",
            "user": {
                "id": 1,
                "name": "Danny"
            },
            "group": {
                "id": 1,
                "title": "CS 2110"
            }
        }
  ]
}

Delete a specific post
DELETE /api/posts/{id}/

Response
<HTTP STATUS CODE 200>
{
"id": <ID>,
    "content": "<CONTENT FOR POST WITH {id}>",
    "user": {
        "id": <USER ID>,
        "name": <STORED NAME FOR USER WITH ID {user_id}>
    },
    "group": {
        "id": <GROUP ID>,
        "title": <STORED TITLE FOR GROUP WITH ID {group_id}>
    }
}
