require_relative "../config/environment.rb"
require 'pry'

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade, :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
        )
        SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    # if self.persisted?
    #   sql = <<-SQL
    #   UPDATE tweets SET username = ?, message = ?
    #   WHERE id = ?
    #   SQL
    #   DB[:conn].execute(sql, self.name, self.message, self.id)
    # else
    #   sql = <<-SQL
    #   INSERT INTO students (name, grade)
    #   VALUES (?, ?)
    #   SQL
    #   DB[:conn].execute(sql, self.name, self.grade)
    #
    #   id_sql = <<-SQL
    #   SELECT * FROM students
    #   ORDER BY id describe
    #   LIMIT 1
    #   SQL
    #   DB[:conn].execute(sql, self.name, self.grade)
    # end

    if self.persisted? #exists
      #update table
      sql = <<-SQL
      -- SQL code here
      UPDATE students SET name = ?, grade = ?
      WHERE ID = ?
      SQL
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    else #doesn't exist
      #insert table
      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
    end

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def persisted?
    !!self.id
  end

  def self.create(name, grade)
    a_student = Student.new(name, grade)
    a_student.save
    a_student
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]

    new_student = Student.new(name, grade, id)
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    self.new_from_db(result)
  end

  def update
    sql = <<-SQL
    UPDATE students SET name = ?, grade = ?
    WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
