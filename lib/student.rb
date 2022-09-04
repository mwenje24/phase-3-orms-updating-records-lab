require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade, :id
  
  def initialize(name, grade, id: nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create(name:, grade:)
      student = Student.new(name: name, grade: grade)
      student.save
  end

  def self.new_from_db(row)
    self.new(id:row[0], name:row[1], grade:row[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql,name).map do |row|
        self.new_from_db(row)
    end
  end

  def update(id)
    sql = <<-SQL
    UPDATE TABLE students SET name = ?, grade = ? WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.id, self.name, self.grade)
  end


end
