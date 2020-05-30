4

(1..3).each { |i| print i} #=> 123
puts "" #=> new line

x = 5

# control flow
unless x > 5
   puts x #=> 5
end

puts x unless x > 5 #=> 5

until x > 5
   puts x #=> 5

   x += 1
end

x = 2

x *= 2 while x < 100
puts x #=> 128

# what is true and what is false 
puts 0 if 0 #=> 0
puts 0 if "" #=> 0, Warning!
puts -1 if nil
puts -1 if false

# triple equal
puts "matches" if /he/ === "hello" #=> matches
puts x if Integer === x #=> 128

# case 
case x
when Integer
   puts "I" #=> I
when 128
   puts x
when 100..130
   puts x
end

# case as if statement
case
   when 1 == 1
      puts true #=> true
   when 0 == 0
      puts true
   else
      puts true
end

# Passing many parameters
def my_fun(arg1, *args, arg_n)
   args.max
end

puts my_fun("a", 2, 3, -3, 100) #=> 3

# Passing a block to a function
def fun1
   yield if block_given?
end

fun1
fun1 { puts "block implicit"} #=> "block implicit"

# explicit way
def fun2(arg1 = 0, &last_arg)
   last_arg.call unless last_arg.nil?
end

fun2
fun2 { puts "block explicit" } #=> "block explicit

# Reading from a file
begin
   if File.exist? "text.txt"
      File.foreach("text.txt") do |line|
         puts line
      end
   end
rescue Exception => e
   puts e.message
end

# Writing to a file
begin
   # The file is automatically closes after the block ends excecution
   File.open("text.txt", "w") do |my_file|
      my_file.puts "line1"
      my_file.puts "line2"
   end
rescue Exception => e
   puts e.message
end

# Read environment variables
puts ENV["USER"]

# quotes
%Q{how are you?
i am fine}.lines { |line| puts line.capitalize }
   #=> How are you?
   #=> I am fine

# Method names are symbols
p "".methods.grep /case/ #=> [:casecmp, :casecmp?, :downcase, :upcase, :swapcase, :upcase!, :downcase!, :swapcase!]

# Arrays
string_arr = %w{yesterday today tomorrow}
p string_arr[-2, 1] #=> ["today"]
p string_arr[1..2] #=> ["today", "tomorrow"]

string_arr[6] = "one_day"
p string_arr #=> ["yesterday", "today", "tomorrow", nil, nil, nil, "one_day"]

p string_arr.sample(3) #=> <random 3 elements>

stack = []
stack.push 1
stack << 2
puts stack.pop #=> 2

q = []
q << 1
q.push 2
puts q.shift #=> 1


# Ranges
r = 1..5
puts r.include? 5 #=> true
puts r === 1.7 #=> true
p ('a'..'z').to_a.sample(5) #=> <5 random characters>

# Hashes 
# puts {:key => "value"} #=> syntax error
   # Ruby thinks it is a block
puts({:key => "value"}) #=> {:key=>"value"}
puts key: "value" #=> {:key=>"value"}

# default value
x = nil
x = x || 5
puts x #=> 5

x ||= 10
puts x #=> 5

# Scope
MY_CONSTANT = -1
def my_method
   # puts x #=> NameError, undefined local variable or method
   x = 0
   puts x #=> 0
   p local_variables #=> [:x]
   
   p MY_CONSTANT #=> -1, it works! Inner scopes can access constants of outer scope
   # MY_CONSTANT = 1 #=> Error, dynamic constant assignment
      # https://stackoverflow.com/questions/6712298/dynamic-constant-assignment
end
my_method

class MyClass
   p MY_CONSTANT #=> -1
   MY_CONSTANT = 1 # We can override its value in the inner scope, without any problems, but the outer scope still not affected
   
   MY_CONSTANT = 2 #=> warning: already initialized constant
   p MY_CONSTANT #=> 2
end
p MY_CONSTANT #=> -1, not affected

# scope of blocks
a = [1, 2 , 3]
sum = 0
a.each do |i,j,k;mylocalvarialbe,x,y| # j,k;mylocalvarialbe,x,y => nil
   sum += i
   another_local_var = sum
end
puts sum #=> 6
# puts another_local_var #=> NameError, undefined

# access control
class C1
   def initialize(val)
      self.set_x = val # works
      puts get_x # works
      # puts self.get_x #=> private method `x' called, NoMethodError
   end
   
   private
      def get_x
         @x
      end

      def set_x= (val)
         @x = val
      end
end
C1.new(0) #=> 0
