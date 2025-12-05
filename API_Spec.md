Api Specification: 

Get all users
GET /api/users/

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

Delete a specific user
DELETE /api/users/{id}/

Get all groups
GET /api/groups/

Create a group
POST /api/group/

Join a specific group
POST /api/groups/{id}/join/

Delete a specific group
DELETE /api/groups/{id}/

Create a post
POST /api/posts/

Get all posts from a specific group
GET /api/groups/{id}/posts/

Delete a specific post
DELETE /api/posts/{id}
