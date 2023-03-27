
function get_product(req, res, knex) {
    knex.select("*").from("product").then((result) => {
      res.send(result)
    })
}

export { get_product }