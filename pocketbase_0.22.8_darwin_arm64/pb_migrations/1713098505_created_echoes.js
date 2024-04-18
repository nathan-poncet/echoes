/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "v7fa1wndr3v8yk2",
    "created": "2024-04-14 12:41:45.106Z",
    "updated": "2024-04-14 12:41:45.106Z",
    "name": "echoes",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "nsarp90d",
        "name": "author",
        "type": "relation",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "collectionId": "_pb_users_auth_",
          "cascadeDelete": false,
          "minSelect": null,
          "maxSelect": 1,
          "displayFields": null
        }
      },
      {
        "system": false,
        "id": "ysbe8nw5",
        "name": "audio",
        "type": "file",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "mimeTypes": [
            "audio/ogg",
            "audio/mpeg",
            "audio/midi",
            "audio/flac",
            "audio/ape",
            "audio/musepack",
            "audio/amr",
            "audio/wav",
            "audio/aiff",
            "audio/basic",
            "audio/aac",
            "audio/x-m4a",
            "audio/mp4",
            "audio/x-unknown",
            "audio/qcelp"
          ],
          "thumbs": [],
          "maxSelect": 1,
          "maxSize": 5242880,
          "protected": false
        }
      },
      {
        "system": false,
        "id": "qkthjl7w",
        "name": "location",
        "type": "json",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSize": 2000000
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
  const collection = dao.findCollectionByNameOrId("v7fa1wndr3v8yk2");

  return dao.deleteCollection(collection);
})
