# Robocode Tournament Server

A robocode tournament organisational tool for helping you organise robocode tournaments.

# REST API

The following REST API is exposed by the server (although some methods are not yet implemented)

## collections

### /robots/:author

### /participants/:id

Participants (keyed on participant-id).  PUT to a non-existent entity will return 404, to keep the DB responsible for id generation.

The participant object looks something like this:
{
	name: 'My Super Awesome Robot',
	class: 'MySuperAwesomeRobot'
}

The 'class' of a participant is the class which extends either Robot or AdvancedRobot which should be used as the robot "definition".

allowed verbs: POST, GET (on entities: GET, PUT, DELETE)

### /tournament/:id

POST (role: admin): schedule a new tournament to be run at the time specified in the body of the POST request
	
GET (role: public): retrieve an array of all tournaments and their starting time

GET /:id (role: public):
 - an array of 'tier' urls which can be used to get more information
 - pass ?flatten=true to this resource to return the standings as a nested array structure (array of array of array of participants, where the first array is tiers, second is bouts, third is participants)

GET /:id/:tier/:bout/:participant

You get the idea, surely. (in other words I'm tired of writing documentation and just want to get on and implement this fucking thing)

## root-level entities

None.