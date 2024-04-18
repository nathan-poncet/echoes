/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("v7fa1wndr3v8yk2")

  collection.listRule = "@request.auth.id = author.id ||\n(\n  @collection.echoes_discovered.user.id = @request.auth.id && \n  @collection.echoes_discovered.echo.id = id\n)"

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("v7fa1wndr3v8yk2")

  collection.listRule = ""

  return dao.saveCollection(collection)
})
