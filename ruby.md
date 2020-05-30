# Ruby <!-- omit in toc -->
- [Introduction](#introduction)
  - [Printing](#printing)
  - [Get input with `gets` and `chomp`](#get-input-with-gets-and-chomp)
  - [Variables](#variables)
    - [Variable Scope and Types](#variable-scope-and-types)
    - [Strings](#strings)
      - [Single quote](#single-quote)
      - [Double quote](#double-quote)
      - [%Q{}](#q)
      - [String manipulation](#string-manipulation)
    - [:Symbols](#symbols)
    - [Numbers](#numbers)
      - [order of operations](#order-of-operations)
  - [Methods](#methods)
    - [Class and Instance Methods](#class-and-instance-methods)
    - [Procs](#procs)
      - [Calling](#calling)
    - [Lambda](#lambda)
      - [The stabby lambda (a common practice)](#the-stabby-lambda-a-common-practice)
    - [Procs VS Lambdas](#procs-vs-lambdas)
  - [Method arguments](#method-arguments)
    - [Named arguments](#named-arguments)
    - [Defaults argument value](#defaults-argument-value)
  - [passing data to methods](#passing-data-to-methods)
    - [splat](#splat)
    - [Optional arguments](#optional-arguments)
  - [Blocks](#blocks)
    - [Create](#create)
    - [Scope](#scope)
    - [Method with blocks](#method-with-blocks)
  - [Loops](#loops)
    - [`for ... in`](#for--in)
    - [`each`](#each)
    - [`select`](#select)
    - [`map`](#map)
    - [`inject`](#inject)
  - [Arrays](#arrays)
    - [creating](#creating)
    - [deleting](#deleting)
  - [Ranges](#ranges)
  - [Hashes](#hashes)
    - [Creating](#creating-1)
    - [Iterating](#iterating)
    - [methods](#methods-1)
  - [Conditionals](#conditionals)
    - [`unless`](#unless)
- [Object Oriented Programming](#object-oriented-programming)
  - [Classes](#classes)
    - [Class Methods](#class-methods)
  - [Inheritance](#inheritance)
  - [Polymorphism](#polymorphism)
    - [super](#super)
  - [Private methods](#private-methods)
  - [Modules](#modules)
    - [As Namespace](#as-namespace)
    - [As Mixin](#as-mixin)
- [Error Handling](#error-handling)
- [Unit Testing](#unit-testing)
  - [`Test::Unit` (MiniTest)](#testunit-minitest)
  - [Rspec](#rspec)
    - [descripe()](#descripe)
    - [before(), after()](#before-after)
    - [it()](#it)
    - [Matchers](#matchers)
- [Tips](#tips)

# Introduction

## Printing
 
| puts "one"                                         | p "three"                                                        | print "five"                    |
| -------------------------------------------------- | ---------------------------------------------------------------- | ------------------------------- |
| will **not return** any value back `nil`           | will **return** the printed value                                | `nil` *(same as `puts`)*        |
| **The way they process the array data structure:** |
| (calls **`to_s`**)                                 | prints the **array in its code form** and returns the value back | *(same as `p`)* but not returns |

## Get input with `gets` and `chomp`
 **`gets`** method prompts the user to enter a value.  
There is an **issue with `gets`**. it returns the value the user enters **along with `\n`** .  

To fix this issue, we can call the chomp method:  `chomp` removes the `\n` character.  
`user_input = gets.chomp`  


## Variables
`name = "Ahmed"`  
`names = ["aaa", "ddd", "231"]`  
Variables can also hold methods, that can be called when needed.  

Ruby **variables do not require semicolons or a data type** to be declared. This feature is possible because **Ruby is a Just-in-Time (JIT) interpreted language,** which automatically recognizes the data type based on what variables are stored.

### Variable Scope and Types
- **Local variable**: scope is limited to the area where they are declared.  

- **Global variable `$`**: is a variable that is **available for the entire application** to use, and this is denoted by a `$ preceding the variable`.  
using global variables is not a good idea since it is hard to track the value of these variables. **It is better to use variables that have limited scope**, such as local or instance variables.  

- **Instance variable `@`** *OOP* : is available to a particular instance. To set instance variables, you need to **use the `@` sign to define a variable**.  

- **CONSTANT**: The syntax is to use **ALL_UPPERCASE_LETTERS_AND_UNDERSORES** while naming your constant.  
In Ruby you can change the constant's value. However, it gives a warning message that says that the constant was already initialized and was changed.
  - scope differs
    - Constants are available anywhere in lower scopes
    - https://stackoverflow.com/questions/6712298/dynamic-constant-assignment

- **Class variable `@@`**: Variables that are available to a particular class.  

### Strings
Both **single and double quotes** work properly.

#### Single quote
- allow scaping **`** and  **\\**
- Shows everything else literally as is.

#### Double quote
- Works with scaping characters like **\\n and \\t**
- String Interpolation `#{variable}`
  - Integrating dynamic values into a string.  
  - We have to **use double-quotes**, otherwise the string will be printed as it is without any interpolation.  
`"Hello, #{name}"`

#### %Q{}
- Behaves like double quotes
- We can **span multiple lines**

#### String manipulation
we can do **method chaining**:  `"str".upcase.downcase.swapcase.reverse  
 for a full list: https://ruby-doc.org/core-2.7.0/String.html   

- Substitution
	- `sub` pass two arguments — the first is the word to be replaced, the second is the replacement
	- `str.sub "run", "walk"`
		-  this method substitutes only the first occurrence of _"run"_
		- To change all occurrences, we need to use the **`gsub`** method, which stands for global substitution.
	- **inplace effect** with **bang `(!)`**
		- gsub!, sub! ... etc
- **`strip`** to remove white spaces from the string edges 
- **`split`** to split a sentence into an array of words or characters 
	- **Tip:** `str.split(//)` split to all of the individual letters (**including spaces**)
- **`join`** to convert an array of characters into a single string.
	- str.join(' ')

### :Symbols
Highly optimized strings
- **Unique** and **Immutable**
- has much less methods than strings
- **Constant names**. And doesn't have to be pre-declared
- Meant to be **Stand for something**,i.e., a flag or an indication 
  - Method names are symbols `p "".methods`
    - in earlier ruby versions, method names weren't symbols but strings
### Numbers
Three main: Integer, Float and Decimal. Decimal is ideal for complex financial applications.
#### order of operations
A good way to remember the order of operations is with the acronym **PEDMAS**, which stands for:

**P**arentheses,
**E**xponent,
**D**ivision,
**M**ultiplication,
**A**ddition,
**S**ubtraction


## Methods
method name : All the words should be in **lowercase and joined by an underscore**.  
```ruby 
def my_fun  
	p "hello"  
end  

my_fun  
```
### Class and Instance Methods
- `def self.class_method`
	- calling: `Class.class_method`
- `def instance_method`
	- calling: `instance.instance_method`  

- Calling the class method `n` time  is a bad practice. This **creates `n` new objects** in the memory.  
Calling all the methods with an instance is a better practice. This won't create a new instance of the class every time.

### Procs
Procs can be stored in variables. They are more flexible than methods.   
We can store a set of processes inside a variable and then call the variable later.  

`my_proc = Proc.new { |n1, n2| n1 + n2}`  
 **We pass arguments inside pipes |...|**. After the pipes is the code logic.  Procs can take **a code block as their parameter**.

#### Calling
There are two ways
- Invoking the call method
	- `my_proc.call(1, 2)`
- Using brackets
	- `myproc[1, 2]`

### Lambda
A bit different to proc  
`my_lambda = lambda { |x, y| x * y }`

#### The stabby lambda (a common practice)
with a different syntax: `my_lambda = -> (x, y) { x * y}`  

### Procs VS Lambdas
There are two key differences
- **lambdas check the number of the passed arguments**
	- Passing wrong number of arguments to lambdas raises an error
	- whereas **Procs ignore** anything after the needed arguments
- **Returning values** { return }
	- In case of lambda, the remaining code of the parent Block (e.g., method) continues running after a lambda return.
	- whereas **proc exits** out of the entire block after a return **and returns a `nil`**.

## Method arguments
### Named arguments
```ruby
def send_msg sender:, receiver:, message:
	#Do send message
end
```
### Defaults argument value 
`def send_msg seneder:, receiver:, message: message = "Hello"`

##  passing data to methods
### splat
We can pass any number of values to the method
- splat arguments
	- `def people(*names)`
- Keyword-based splat arguments
	- Use with  dynamic data that has a {key: value} structure, e.g., hash data structure
	- `def people **names_and_ages`
		-  `names_and_ids.each do |id, name|`
### Optional arguments
```ruby
def my_fun options = {} 
  p options[:second] # 123
  p options[:third] # **nil**
end
my_fun first: "some string", second: 1234

```


## Blocks
**NOTICE**: Methods (and blocks) implicitly return the value of the last statement.   

### Create
There are two ways to create blocks in Ruby 
- Using curly braces `repeat = Proc.new { |msg| msg * 5 }`
  - should used when we put all code on the same line
- Using *`do … end`*   
```ruby
Proc.new do |args|    
	# logic    
end
  ```
  
### Scope
- Blocks **Inherit outer scope**
- Blocks can become **clousers**
  - Remerber the context where they were defined, and use this context wherever they are called
- https://www.rubyguides.com/2019/03/ruby-scope-binding/


### Method with blocks
Two ways:
- Implicit
	- `block_given?` checks if a block is passed to the method
	- `yield` calls the block
- Explicit
	- **&** preceding the last_parameter
	- `last_parameter.call` 
		- check with `last_parameter.nil?`


## Loops
### `for ... in`
- `for i in 0...10` *10 is not included*
- `for i in 0..10` *10 is included*

### `each`
Good when we're iterating over collections
```ruby
arr.each do |i| # we can use block variables
  p i
end
```
**or**
```
arr.each { |i| p i }
```
### `select`
for querying collections
```ruby
even_nums= (1...10).to_a.select do |i|
  i.even?
end

# shortcuts  

p (1...10).to_a.select { |i| i.even? }

# shorter
# avoid using a block variable with `&`
p (1...10).to_a.select(&:even?)

```

### `map`
```ruby
p ["1", "2", "3", "4"].map(&:to_i)

p Hash[["1", "2", "3", "4"].map { |i| [i, i.to_i] }]

`puts ('a'..'e').to_a.map.with_index(1) { |c, i| "#{c}: #{i}"}.join(', ')`

```

### `inject`
```ruby
#  keeps track of the variable value with each iteration
# `*` is a method, not an operator
[1, 2, 3, 4, 5, 6, 7].inject(&:*)
```


## Arrays
### creating
`x = [1,2,3]`  
`x = Array.new`

### deleting
- arr.delete(value)   
```ruby
arr = [0, "hello", "world", 13, "hello"]
arr.delete("hello")
p arr.length # 3
```
- arr.delete_at(index)
	- returns the deleted item
- `arr.delete_if {|element| < logic>}`

## Ranges
- **start and end** are only **stored**
- **`0..10`** using **..** is inclusive 10 is in-range
- **`(1...10).to_a`**
	- converting a range of integers into an array **`to_a`**

## Hashes
The order of adding elements is maintained **v 1.9**
### Creating
```ruby
people = Hash.new(0) # Return 0 when a key doesn't exist (normally returns nil)
people = { Ali: 30, Ahmed: 23, Hassan: 27 } # Ruby 1.9
people = { "Ali" => 30, "Ahmed" => 23, "Hassan" => 27 }
people = { :Ali => 30, :Ahmed => 23, :Hassan => 27 } 

people[:John] = 1

# Deleting
people.delete(:John)
```

### Iterating
- `hash.each_key`
- `hash.each_value`
- `hash.each_pair`

### methods
- hash.invert
- hash.merge(another_hash)
- Array(hash)
- hash.to_a
- hash.keys, hash.values

## Conditionals
### `unless`
Equals to **if !**
```ruby
unless arr.empty?
  arr.each { |i| p i }
end

# shorten
arr.each { |i| p i } unless arr.empty?

# work the same as
arr.each { |i| p i } if !arr.empty?

```

# Object Oriented Programming 
## Classes
- Class names: need to be **CamelCase”**
- @instance_variables are **private**
  - access using getters and setters
- methods are **public** by default

```ruby
class GoodMan
	def initialize(name, age, address = "Egypt")
		@name = name
		@age = age
		@address = address
	end
  
  attr_accessor :name, :age, :address # getter and setter

  attr_reader :address # getter
  attr_writer :address # setter

  def age # getter
    @age
  end

  def age= (value) # setter
    @age = value
  end

  def summary
    @new_var = "some new instance variable"
		p @name
		p age
    p address
	end
end

Ali = GoodMan.new
Ali.name = "Ali"
Ali.summary
p Ali.instance_variables
```
### Class Methods
- `self` outside of method refers to **class object**
- defining a class method
  ```ruby
  class MyClass
    # using self
    def self.class_method1(var)
      puts var
    end

    # using << self
    class << self
      def class_method2(var)
        puts var
      end
    end
  end

  # outside the class
  def MyClass.class_method3(var)
    puts var
  end

  Myclass.class_method1(1)
  Myclass.class_method2(2)
  Myclass.class_method3(3)
  ```

## Inheritance
- every class implicitly inherits from `Object` class
  - and `Object` class inherits from `BasicObject`!
- `ChildClass` **`<`** `ParentClass`
  - **no multiple ineritance**, use **mixins** instead

## Polymorphism
when a child class overrides the behavior provided by the parent class.

### super
to combine the behavior of both the parent and child classes
```ruby
class Child < Parent
	def method
		super
		p "Hello from the child class"
	end
end
```

## Private methods
private methods are placed after all the public methods, and preceded by **`private`** keyword.

## Modules
### As Namespace
A way to not to have class names collision.  
```ruby
module MyModule
  class MyClass
    def my_method
    end
  end
end
```
`MyModule::MyClass`

### As Mixin
- A way to **share *mix-in* code among multiple classess**. *i.e, interface, contract*
  ```ruby
  module MyMixin
    attr_accessor :name
    def summary
      puts @name
    end
  end

  class MyClass
    include MyMixin
  end
  ```
- **We can includes built-in modules** like `Enumerable`
  ```ruby
  class MyClass
    include Enumerable

    attr_accessor :name, :elements

    def each
      yield name
      @elements.each { |element| yield element }
    end

    # or
    def each(&block)
      @elements.each { |element| block.call element }
      # or 
      # elements.each(&block)
    end
    # https://stackoverflow.com/questions/7220634/how-do-i-use-the-enumerable-mixin-in-my-class

  end
  ```

# Error Handling
```ruby
begin
	p 1/0
rescue ZeroDivisionError => e
	p "Error! #{3}"
end
```

# Unit Testing
## `Test::Unit` (MiniTest)
- Make a test class that extends **`Test::Unit::TestCase`**
- Every method start with **`test_`** gets **excecuted** when the test class runs as a test case
- **Pr-test** methods that **excecute before** every `test_` method:
  - `setup()`
  - `teardown()`
- Assertions
  - `assert_equal(expected, actual)`
  - `assert_raise Expected_Error { < code will cause an error> }`
  - dot **.** means **pass**, and **F** means **fail**
  ```ruby
  require "test/unit"
  require_relative "my_class"

  class MyClassTest < Test::Unit::TestCase
    def setup
      @instance = MyClass.new(0)
    end

    def test_value
      assert_equal 0, @instance.value
    end

    def test_raise_error
      assert_raise SomeError { @instance.do(-1) }
    end
  end
  ```

## Rspec
- `rspec --init`
- `rspec --format documentation`

### descripe()
- `descripe(<"String"|Class>)`
- contains a set of **related tests**
- all tests must be inside `descripe`

### before(), after()
- `:each` run before/after **each** test
- `:all` run **once** before/after all tests

### it()
- Test logic for each test case
- `it("Test behavior description")`
  
### Matchers
- `eq, be_true, raise_error`
- **be_** <predicate_mothod>, e.g., *be_nil, be_car, be_even*
  - if the tested object has predicate/boolean methods, they will automatically appear in matchers, (include ruby built-in methods)

  ```ruby
  require "rspec"
  require_relative "../my_class"

  descripe MyClass do
    before { @instance = MyClass.new(0) }

    it "should return the val attribute" { expect(@instance.val).to eq 0 }
  end
  ```

# Tips
- `people = Hash.new(0)`
  - Return `0` when a key doesn't exist `people["not_a_key"]`
  - normally returns `nil`
  - if a **hash** is the **last argument** of a method, (*not including a block*)
    - we can drop the **`{}`**
- **`select(&:even?)`**
	-  Using **`&`** before a method runs the method against each element in the collection.
- **`%w(a b c).map.with_index(1)`**
	- output: `a: 1, b: 2, c: 3`
-  **`+` and `*`** are **not operators** in Ruby; rather, **they are methods**
- `self`
  ```ruby
  attr_writer :age
  def initialize(age_val)
    age = age_val # local variable
    self.age = age_val # instance method (setter)
  end
  ```
