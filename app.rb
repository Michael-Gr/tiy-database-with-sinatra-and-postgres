require "sinatra"
require "sinatra/reloader" if development?
require "pg"

get "/" do
  erb :home
end

get "/employees" do
  database = PG.connect(dbname: 'tiy-database')
  @rows = database.exec('SELECT * FROM employees')

  erb :employees
end

get "/show_employee" do
  id = params["id"]

  database = PG.connect(dbname: 'tiy-database')
  @rows = database.exec('SELECT * FROM employees where id = $1', [id])

  erb :show_employee
end

get "/new_employee" do
  erb :new_employee
end

post "/create_employee" do
  name = params["name"]
  address = params["address"]
  phone = params["phone"]
  salary = params["salary"]
  github = params["github"]
  slack = params["slack"]
  position = params["position"]

  database = PG.connect(dbname: "tiy-database")
  database.exec("INSERT INTO employees(name, address, phone, salary, github, slack, position) VALUES($1, $2, $3, $4, $5, $6, $7)",[name, address, phone, salary, github, slack, position])

  redirect to("/employees")
end

get "/edit_employee" do
  id = params["id"]

  database = PG.connect(dbname: 'tiy-database')
  @rows = database.exec('SELECT * FROM employees where id = $1', [id])

  erb :edit_employee
end

post "/submit_edit" do
  id = params["id"]

  database = PG.connect(dbname: "tiy-database")
  database.exec('DELETE FROM employees WHERE employees.id = $1', [id])

  name = params["name"]
  address = params["address"]
  phone = params["phone"]
  salary = params["salary"]
  github = params["github"]
  slack = params["slack"]
  position = params["position"]

  database.exec("INSERT INTO employees(name, address, phone, salary, github, slack, position) VALUES($1, $2, $3, $4, $5, $6, $7)",[name, address, phone, salary, github, slack, position])

  redirect to("/employees")
end

get "/delete_employee" do
  @id = params["id"]

  database = PG.connect(dbname: 'tiy-database')
  @rows = database.exec('SELECT * FROM employees where id = $1', [@id])

  erb :delete_employee
end

get "/delete" do
  id = params["id"]

  database = PG.connect(dbname: "tiy-database")
  database.exec('DELETE FROM employees WHERE id = $1', [id])

  redirect to("/employees")
end
