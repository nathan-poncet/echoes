/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("v7fa1wndr3v8yk2")

  collection.listRule = "@request.auth.id = author.id"

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("v7fa1wndr3v8yk2")

  collection.listRule = null

  return dao.saveCollection(collection)
})
