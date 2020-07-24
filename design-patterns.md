# Design Patterns <!-- omit in toc -->

- [GoF Categories (23 patterns)](#gof-categories-23-patterns)
- [Creational Design Patterns](#creational-design-patterns)
  - [Singleton Pattern](#singleton-pattern)
    - [How to implement](#how-to-implement)
    - [Multi-Threading (Thread-Safety)](#multi-threading-thread-safety)
  - [Factory](#factory)
    - [Factory objects](#factory-objects)
    - [Factory Method Pattern](#factory-method-pattern)
- [Structural Design Patterns](#structural-design-patterns)
  - [Facade Pattern](#facade-pattern)
  - [Adapter Pattern](#adapter-pattern)
  - [Composite pattern](#composite-pattern)
  - [Proxy Pattern](#proxy-pattern)
  - [Decorator Pattern](#decorator-pattern)
- [Glossary](#glossary)

Definition: ... .   
Desin patterns are defined by their purpose ot intent, and not the exact code.
## GoF Categories (23 patterns)
- Creational
  - Creational patterns are all about different ways to create objects 
- Structural
  - Are about the relationships between objects (Inheritance and Composition)
  - How objects are connected to each others
  - how classes and subclasses interact through inheritance
- Behavioral
  - Are about interaction or communication between objects ( better interaction between objects, how to provide lose coupling, and flexibility to extend easily in future)
  - How objects distribute work
  - How independent objects work towards a common goal (the overall goal and the purpose of each the objects)

## Creational Design Patterns

### Singleton Pattern
Having one and only one object of a class. That is globally accessible within the program.  
#### How to implement 
- Give the class a private constructor that cannot be called outside of the class
- Create a class variable that will refer to the one instance of the class
  - the variable is private, it can be only modified within the class
- Create a public method that will create a single instance, and set that variable to reference the instance
  - but only if an instance doesn't exist already
  - If there is already an object, the method will return it
  - This method replaces the normal constructor
  - **Lazy Creation** The object is not created until it is needed
#### Multi-Threading (Thread-Safety)
<!-- TODO -->

### Factory
It allow client code to operate on **generalizations**. (Coding to an interface, not an implementation)

#### Factory objects
Responsible of creating objects of particular types (concrete instantiation). It decides which sub-category of object to create.  
We delegate the responsibility of creating concrete objects to the factory object.  
So methods that use these factories (clients) can focus on other behavior.  
Factory objects are useful if many parts of a software want to create the same objects.    
It is not a pattern.  

#### Factory Method Pattern
Approaches the creation of specific types of objects in a different way than factory objects.  
Instead of using another object to create objects, it uses a separate method **in the same (creator) class** to create the objects.  
The factory method is defined by the subclasses, letting the **subclasses decide how objects are made**.  
Any subclasses we define must implement the factory method. 
  

## Structural Design Patterns
### Facade Pattern
Provides a **single, simplified interface** for client classes to interact with a subsystem.  
A wrapper class that **encapsulates** a subsystem in order to hide its complexity, (**Information Hiding**)  
and acts as a **point of entry** into a subsystem. It doesn't add more functionality.  
It can be used to wrap all the interfaces and classes of a subsystem.  

### Adapter Pattern
When systems have **incompatible interfaces**. Say, the output of one system (client) may not confirm with the input of another system (adaptee).  
The adapter pattern provides a compatible interface (that the client will use) to facilitate the communication between the two systems.  
The adapter implements the target interface. It confirms to what the client is expecting to see.  
The adapter translates the clients messages into a form that the adapter will understand.    
The adaptee is hidden from the client by the **wrapping** adapter class.  

### Composite pattern
**Composite class** aggregates any class that implements the supertype interface.  
It allows us to traverse through the objects it contains.  
It can contain other composite objects. ***(recursive composition)***   

**Leaf class** a non-composite type. It ends the tree where it is.

### Proxy Pattern
Use a proxy class to represent/**wrap** a real subject class. **Acts as a lightweight version of the original object**.  

It can perform the same *(light)* tasks as the original object,  
but may delegate/redirect *(substantive)* requests to the original object *(defer creating resource intensive objects until needed)*.  

The real object is usually a **resource intensive to instantiate**, **contains sensitive information *(use proxy for access control)***,  
or when **the subject class exists remotely *(Use local proxy class to have all needed objects locally)***.  

### Decorator Pattern
Allows us to dynamically attach additional behaviors to an object.  

It make use of aggregation *(a has-a relationship)* to combine behaviors at runtime.  
It builds a stack of objects *(aggregation stack)*, where each level of the stack contains an object that has its own behavior  
and augments *(one-to-one relationship)* the object below it.  

Calling the top element would start a series of calls till reaching the base object *(recursively)* that would respond with its behavior.  
Then the object on top of it would respond, and so on.


<!-- ## State
- Allows an object to behave differently when its state changes. 
- Issues solving
  - Maintainability issues
  - extensibility issues 
- based on composition
- Single Responsibility Principle?
- Open Closed principle
  - Our classes should be
    - open for extension,
    - closed for modification.
  - so we are not allowed to change the code in our classes, but we can only extending.
  - We can add new functionality without changing the existing code.
    - We can support new functions/features by adding new classes 
- resources
  - https://refactoring.guru/design-patterns/state
  - https://youtu.be/NU_1StN5Tkk?t=3262 (Mosh Hamedani) -->


## Glossary
- Concrete
  - **Concrete instantiation** is the act of object creation, usually with the **`new`** keyword in some languages such as Java.
  - The **ConcreteClass** is called concrete because it is responsible for **concrete instantiation**. It is a subclass of the AbstractClass
