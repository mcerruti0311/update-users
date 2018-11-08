// constants
string oldManager = 'Jeff Venturini';
string oldDirector = 'Jeff Venturini';
string newManager = 'Julia Prybyla';
string newDirector = 'Jeff Venturini';
string notInProfile = 'Campus - Leadership - LP20';
integer userSize = 127;
boolean updateManager = true;
boolean updateDirector = true;
boolean runUpdate = false;

// Lookup new manager
List<user> managers =
  [
    SELECT
      Id,
      Name
    FROM User
    // use employee number
    WHERE Name = :newManager
    LIMIT 1
  ];

system.assert(managers[0].Name  == newManager, 'Not the Expected Manager');
system.debug('Manager: ' + managers[0].Name);


// Lookup new director
List<user> directors =
  [
    SELECT
      Id,
      Name
    FROM User
    WHERE Name = :newDirector
    LIMIT 1
  ];
// size greater than size 0 assert

system.assert(directors[0].Name  == newDirector, 'Not the Expected Director');
system.debug('Director: ' + directors[0].Name);

// Various SOQL statement examples for users depending on the situation
List<user> users =
  [
    SELECT
      Director__r.Name,
      Id,
      Manager.Name,
      Name
  FROM User
  WHERE IsActive = true
  AND Director__r.Name = :oldDirector
  ];

/*
List<user> users =
    [
      SELECT
        Director__r.Name,
        Id,
        Manager.Name,
        Name
      FROM User
      WHERE IsActive = true
        AND Director__r.Name = :oldDirector
        AND Manager.Name = :oldManager
	];

List<user> users =
    [
      SELECT
        Director__r.Name,
        Id,
        Manager.Name,
        Name,
        Profile.Name,
        UserRole.Name
      FROM User
      WHERE IsActive = true
        AND Director__r.Name = :oldDirector
        AND (NOT Profile.Name IN (:notInProfile))
	];

List<user> users =
    [
      SELECT
        Director__r.Name,
        Id,
        Manager.Name,
        Name,
        Profile.Name,
        UserRole.Name
      FROM User
      WHERE IsActive = true
        AND Director__r.Name = :oldDirector
        AND (NOT UserRole.Name LIKE '%Apple%')
        AND (NOT UserRole.Name LIKE '%Director%')
        AND (NOT UserRole.Name LIKE '%Nike%')
        AND UserRole.Name != null
    ];
*/

system.assert(users.size() == userSize, 'Not the Expected Amount of Users');
system.debug('user size:' + users.size());

// create usersToUpdate

for(User usersToUpdate : users) {
  if(updateManager) {
    usersToUpdate.ManagerId = managers[0].Id;
    // add back log of users 
  }

  if(updateDirector) {
    usersToUpdate.Director__c = directors[0].Id;
  }
}

if(runUpdate) {
  update users;
}
