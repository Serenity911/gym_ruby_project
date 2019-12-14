require_relative( "../db/sql_runner" )


class CourseClass

  attr_reader :id, :name, :max_capacity, :venue_id

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @max_capacity = options['max_capacity'].to_i
    @venue_id = options['venue_id'].to_i
    @membership_level = options['membership_level']
    @members_array = []
    # add date
    # add days of week
    # add instructors
  end


  # create a course_class

  def save()
    sql = "INSERT INTO course_classes
          (name, max_capacity, venue_id, membership_level)
          VALUES
          ($1, $2, $3, $4)
          RETURNING id"
    values = [@name, @max_capacity, @venue_id, @membership_level]
    @id = SqlRunner.run( sql, values ).first['id'].to_i
  end

  # delete all the course_classes

  def self.delete_all()
    sql = "DELETE FROM course_classes"
    SqlRunner.run( sql )
  end

  # show all the course_classes

  def self.all()
    sql = "SELECT * FROM course_classes"
    result = SqlRunner.run( sql )
    return result.map{|courseclass| CourseClass.new( courseclass )}
  end

  # delete one course_class

  def destroy()
    sql = "DELETE FROM course_classes WHERE id = $1"
    values = [@id]
    SqlRunner.run( sql, values )
  end

  # show all classes for a venue
  def self.all_by_venue(id)
    sql = "SELECT * FROM course_classes WHERE venue_id = $1"
    values = [id]
    result = SqlRunner.run( sql, values )
    return result.map{|courseclass| CourseClass.new( courseclass )}
  end

  # update one course class

  def update()
    sql = "UPDATE course_classes SET (
    name, max_capacity, venue_id, membership_level
    ) = (
    $1, $2, $3, $4
    )
    WHERE id = $5
    "
    values = [@name, @max_capacity, @venue_id, @membership_level, @id]
    SqlRunner.run( sql, values )
  end

  # find by id
  def self.find( id )
    sql = " SELECT * FROM course_classes WHERE id = $1"
    values = [id]
    result = SqlRunner.run( sql, values )
    return CourseClass.new( result.first )
  end

  # get venue name
  def venue_name()
    Venue.find(@venue_id).name()
  end

  # check if still availability
  def availability?
    return  @members_array.length < @max_capacity
  end

  def correct_membership?(member)
    return member.membership == @membership_level
  end

  # add member to class
  # check if still availability -> call method -V
  # check if member is active --> call method member -V
  # check if member has the right type of membership --> update course class
  # add member to class members_array
  # increase counter in member --> call method member

end
