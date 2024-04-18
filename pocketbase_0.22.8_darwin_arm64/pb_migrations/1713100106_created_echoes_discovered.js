/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "w38dwz7zsnxf5nu",
    "created": "2024-04-14 13:08:26.189Z",
    "updated": "2024-04-14 13:08:26.189Z",
    "name": "echoes_discovered",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "wldr3hxn",
        "name": "echo",
        "type": "relation",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "collectionId": "v7fa1wndr3v8yk2",
          "cascadeDelete": false,
          "minSelect": null,
          "maxSelect": 1,
          "displayFields": null
        }
      },
      {
        "system": false,
        "id": "mgvxgwgw",
        "name": "user",
        "type": "relation",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "collectionId": "_pb_users_auth_",
          "cascadeDelete": false,
          "minSelect": null,
          "maxSelect": 1,
          "displayFields": null
        }
      }
    ],
    "indexes": [],
    "listRule": null,
    "viewRule": null,
    "createRule": null,
    "updateRule": null,
    "deleteRule": null,
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("w38dwz7zsnxf5nu");

  return dao.deleteCollection(collection);
})
