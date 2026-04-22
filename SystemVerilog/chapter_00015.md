# SystemVerilog Classes: Object-Oriented Programming for Advanced Verification

## Introduction: Building Scalable and Reusable Testbenches with OOP

SystemVerilog classes bring the power of **object-oriented programming (OOP)** to hardware verification, enabling the creation of modular, reusable, and highly scalable testbenches.  Classes serve as blueprints for creating objects, which encapsulate both **data (properties)** and **behavior (methods)**. This object-oriented approach is fundamental to advanced verification methodologies like the Universal Verification Methodology (UVM) and significantly enhances the efficiency and maintainability of verification environments.

**Core OOP Principles and Their Benefits in Verification:**

*   **Encapsulation**: Bundling data (properties) and methods that operate on that data within a single unit (the class). This hides internal implementation details and protects data integrity, promoting modularity and reducing unintended side effects. In verification, encapsulation helps create self-contained, reusable components like transaction objects, monitors, and drivers.
*   **Inheritance**:  Creating new classes (derived classes) that inherit properties and methods from existing classes (base classes). Inheritance fosters code reuse, reduces redundancy, and establishes a clear hierarchy of components. In verification, inheritance is used to extend and specialize base classes to create variations of components, like different types of transactions or agents, while sharing common functionalities.
*   **Polymorphism**:  The ability of objects of different classes to respond to the same method call in their own specific way. Polymorphism, particularly through **virtual methods**, enables dynamic method dispatch, where the method executed is determined at runtime based on the actual object type. In verification, polymorphism allows for flexible and adaptable testbenches that can handle different types of components or scenarios through a common interface.

By leveraging these OOP principles, SystemVerilog classes empower verification engineers to build sophisticated testbenches that are:

*   **Modular**:  Composed of independent, self-contained objects, making it easier to design, implement, and debug individual components.
*   **Reusable**:  Classes and objects can be reused across different parts of a project or in multiple projects, saving development time and promoting consistency.
*   **Scalable**:  OOP principles facilitate the creation of large and complex verification environments that can be efficiently managed and extended as design complexity grows.
*   **Maintainable**:  Well-structured, object-oriented code is generally easier to understand, modify, and maintain compared to procedural or flat code.
*   **Extensible**: Inheritance and polymorphism make it straightforward to extend and adapt existing verification components to new requirements or design changes.

## Defining Classes: Blueprints for Objects

Classes are defined using the `class` keyword, followed by the class name and the class body enclosed within `endclass`.  By default, class members (properties and methods) have **public** access, meaning they can be accessed from anywhere. To control access and implement encapsulation, SystemVerilog provides the `local` and `protected` keywords.

### Example: A Simple Class Definition

```SV
// Define a class named 'SimpleClass'
class SimpleClass;
  int data;         // Public property (integer data) - accessible from anywhere

  // Method to display the value of 'data'
  function void display_data();
    $display("Data value is: %0d", data);
  endfunction : display_data // Named function end for clarity (optional but recommended)

endclass : SimpleClass // Named class end for clarity (optional but recommended)
```

In this `SimpleClass` example:

*   `class SimpleClass; ... endclass : SimpleClass` declares a class named `SimpleClass`. The `: SimpleClass` after `endclass` is optional but improves readability, especially for longer classes.
*   `int data;` declares a public property named `data` of type `int`.  Since no access modifier (`local`, `protected`, `automatic`, `static`) is specified, it defaults to `public` access.
*   `function void display_data(); ... endfunction : display_data` defines a public method named `display_data`. It's a `function` that returns `void` (no return value) and uses `$display` to print the value of the `data` property.  The `: display_data` after `endfunction` is also optional but enhances readability.

## Creating Objects: Instances of Classes

Objects are concrete instances of classes.  Think of a class as a cookie cutter and objects as the cookies created using that cutter.  Objects are dynamically created at runtime using the `new()` constructor.  Memory for objects is allocated dynamically, and objects are accessed and manipulated through object handles (pointers).

### Example: Instantiating and Using a Class Object

```SV
module class_example_module;

  initial begin
    SimpleClass my_object;          // Declare an object handle 'my_object' of type 'SimpleClass'
    my_object = new();            // Instantiate an object of 'SimpleClass' using new() and assign its handle to 'my_object'

    my_object.data = 42;          // Access the 'data' property of the object using the handle and assign the value 42
    my_object.display_data();    // Call the 'display_data()' method of the object using the handle

    $display("Value of my_object.data: %0d", my_object.data); // Access and display the 'data' property again

  end

endmodule : class_example_module
```

In this example:

*   `SimpleClass my_object;` declares a variable `my_object` that can hold a handle to an object of type `SimpleClass`.  At this point, `my_object` is just a handle and does not yet point to an actual object (it's initially `null`).
*   `my_object = new();`  This is the crucial step of object instantiation. `new()` is the constructor for the `SimpleClass`. It dynamically allocates memory to create a new object of type `SimpleClass` and returns a handle (a pointer or reference) to this newly created object. This handle is then assigned to the `my_object` variable.
*   `my_object.data = 42;` uses the object handle `my_object` and the dot operator (`.`) to access the `public` property `data` of the object and assign the value `42` to it.
*   `my_object.display_data();` similarly uses the handle to call the `public` method `display_data()` on the object. This method then executes, printing the value of `data` to the simulation console.
*   `$display(...)` demonstrates accessing and displaying the `data` property directly after it has been set and displayed by the method.

## Inheritance: Creating Class Hierarchies for Code Reusability

Inheritance is a fundamental OOP principle that allows you to create new classes (derived or child classes) based on existing classes (base or parent classes).  The derived class automatically inherits all the *accessible* properties and methods of the base class.  SystemVerilog uses the `extends` keyword to establish inheritance.  The `super` keyword allows a derived class to explicitly access members of its parent class, particularly when overriding methods.

### Example: Base Class `Animal` and Derived Class `Dog`

```SV
// Base class: Animal
class Animal;
  string name; // Public property: animal's name

  // Method: generic animal sound
  function virtual void speak(); // 'virtual' keyword enables polymorphism
    $display("%0s makes a generic animal sound", name);
  endfunction : speak

endclass : Animal

// Derived class: Dog, inheriting from Animal
class Dog extends Animal;
  // Inherits 'name' property and 'speak()' method from Animal

  // Override the 'speak()' method to provide Dog-specific behavior
  function virtual void speak(); // Override base class method - still 'virtual' for further derivation
    super.speak();          // Optional: Call the base class's speak() method first
    $display("%0s barks: Woof!", name); // Then add Dog-specific barking behavior
  endfunction : speak

  function void wag_tail(); // Method specific to Dog class
    $display("%0s is wagging its tail", name);
  endfunction : wag_tail

endclass : Dog

module inheritance_example_module;
  initial begin
    Dog my_dog = new(); // Create an object of the derived class 'Dog'
    my_dog.name = "Buddy"; // Set the 'name' property (inherited from 'Animal')

    my_dog.speak();       // Call the 'speak()' method - dynamically dispatched to Dog's implementation
    // Output will be:
    // Buddy makes a generic animal sound
    // Buddy barks: Woof!

    my_dog.wag_tail();    // Call the Dog-specific 'wag_tail()' method

    Animal my_animal;      // Declare a handle of the base class type 'Animal'
    my_animal = my_dog;    // Assign the 'Dog' object handle to the 'Animal' handle (upcasting - always allowed)

    my_animal.speak();     // Call 'speak()' method using the 'Animal' handle - still dynamically dispatched to Dog's implementation!
    // Output will be the same as my_dog.speak():
    // Buddy makes a generic animal sound
    // Buddy barks: Woof!

    // my_animal.wag_tail(); // Error! 'wag_tail()' is not a member of the 'Animal' class, even though 'my_animal' is pointing to a 'Dog' object.
                               // Base class handles can only access members defined in the base class (or overridden in derived classes).
  end
endmodule : inheritance_example_module
```

Key points in the inheritance example:

*   `class Dog extends Animal;` declares `Dog` as a derived class of `Animal`, inheriting properties and methods from `Animal`.
*   `super.speak();` inside `Dog::speak()` calls the `speak()` method of the parent class (`Animal`). `super` is used to explicitly access parent class members.
*   `my_animal.speak();` demonstrates polymorphism. Even though `my_animal` is an `Animal` handle, because it points to a `Dog` object and `speak()` is `virtual`, the `Dog`'s `speak()` method is executed at runtime (dynamic dispatch).
*   `my_animal.wag_tail();` results in an error because `wag_tail()` is specific to `Dog` and not defined in the `Animal` class. Base class handles can only access members defined in the base class or overridden in derived classes.

## Polymorphism: Dynamic Method Dispatch for Flexible Behavior

Polymorphism, specifically through **virtual methods**, is a powerful OOP feature that allows objects of different classes to be treated through a common base class interface.  The key mechanism for polymorphism in SystemVerilog is the `virtual` keyword used in method declarations. When a method is declared `virtual` in a base class, derived classes can override it with their own implementations. When you call a virtual method through a base class handle that actually points to a derived class object, SystemVerilog dynamically determines and executes the *overridden method in the derived class*, not the base class method. This is known as **dynamic method dispatch** or runtime polymorphism.

### Example: Polymorphism with `Shape`, `Circle`, and `Square` Classes

```SV
// Base class: Shape
class Shape;
  // Virtual function: to be overridden by derived classes
  virtual function void draw();
    $display("Drawing an unknown shape"); // Default implementation for generic shapes
  endfunction : draw
endclass : Shape

// Derived class: Circle, inheriting from Shape
class Circle extends Shape;
  // Override the 'draw()' method for circles
  virtual function void draw(); // 'virtual' is still needed in derived class for further polymorphism
    $display("Drawing a circle");
  endfunction : draw
endclass : Circle

// Derived class: Square, inheriting from Shape
class Square extends Shape;
  // Override the 'draw()' method for squares
  virtual function void draw();
    $display("Drawing a square");
  endfunction : draw
endclass : Square

module polymorphism_example_module;
  initial begin
    Shape shape_obj;       // Declare a handle of the base class 'Shape'

    Circle circle_obj = new(); // Create a Circle object
    Square square_obj = new(); // Create a Square object

    shape_obj = circle_obj;  // Assign Circle object handle to Shape handle (upcasting)
    shape_obj.draw();       // Call 'draw()' using Shape handle - dynamically dispatches to Circle::draw()
    // Output: Drawing a circle

    shape_obj = square_obj;  // Assign Square object handle to Shape handle (upcasting)
    shape_obj.draw();       // Call 'draw()' using Shape handle - dynamically dispatches to Square::draw()
    // Output: Drawing a square

    Shape shape_array[2];   // Declare an array of Shape handles
    shape_array[0] = circle_obj; // Store Circle object handle in the array
    shape_array[1] = square_obj; // Store Square object handle in the array

    foreach (shape_array[i]) begin // Iterate through the array of Shape handles
      shape_array[i].draw();    // Call 'draw()' on each element - dynamic dispatch based on actual object type
    end
    // Output:
    // Drawing a circle
    // Drawing a square
  end
endmodule : polymorphism_example_module
```

In this polymorphism example:

*   `virtual function void draw();` in the `Shape` class declares `draw()` as a virtual method. This makes it eligible for overriding and dynamic dispatch in derived classes.
*   `Circle` and `Square` classes `extends Shape` and override the `draw()` method with their specific implementations.
*   `Shape shape_obj;` declares a handle of the base class type `Shape`. This handle can point to objects of `Shape`, `Circle`, or `Square` types (or any other class derived from `Shape`).
*   `shape_obj = circle_obj;` and `shape_obj = square_obj;` demonstrate **upcasting**, where handles of derived classes (`Circle`, `Square`) are assigned to a handle of the base class (`Shape`). Upcasting is always safe and allowed in OOP.
*   `shape_obj.draw();` calls demonstrate dynamic dispatch.  The actual method that gets executed (`Circle::draw()` or `Square::draw()`) is determined at *runtime* based on the *actual object type* that `shape_obj` is currently pointing to, not just the handle type (`Shape`).
*   The `shape_array` example further illustrates polymorphism by showing how an array of base class handles can hold objects of different derived classes, and calling a virtual method on each element will result in the correct derived class method being invoked.

## Encapsulation: Data Hiding and Controlled Access

Encapsulation is the principle of bundling data (properties) and methods that operate on that data within a class, and controlling access to the internal data to protect it from direct, unauthorized modification.  SystemVerilog provides access modifiers (`local` and `protected`) to implement encapsulation.

*   **`local`**:  Declares a member (property or method) as *private* to the class in which it is declared. `local` members can only be accessed from within the class itself. They are not accessible from derived classes or from outside the class.
*   **`protected`**: Declares a member as accessible within the class in which it's declared and in any classes derived from that class (subclasses). `protected` members are not accessible from outside the class hierarchy.
*   **`public` (default)**: Members declared without an explicit access modifier are public. They are accessible from anywhere: within the class, from derived classes, and from outside the class through object handles.

Encapsulation is crucial for:

*   **Data Hiding**:  Preventing direct access and modification of internal data, protecting data integrity and preventing accidental corruption.
*   **Abstraction**:  Hiding complex implementation details and exposing only a well-defined public interface to interact with objects. This simplifies the use of classes and reduces dependencies on internal implementation.
*   **Modularity**:  Making classes more self-contained and independent, improving modularity and reusability.

### Example: Encapsulation with `BankAccount` Class

```SV
class BankAccount;
  local int balance; // Private property: 'balance' - only accessible within BankAccount class

  // Public method: to deposit money into the account
  function void deposit(int amount);
    if (amount > 0) begin
      balance += amount; // Access and modify the private 'balance' property from within the class
      $display("Deposit of $%0d successful. New balance: $%0d", amount, balance);
    end else begin
      $display("Invalid deposit amount. Amount must be positive.");
    end
  endfunction : deposit

  // Public method: to withdraw money from the account
  function bit withdraw(int amount);
    if (amount > 0 && amount <= balance) begin
      balance -= amount; // Access and modify 'balance'
      $display("Withdrawal of $%0d successful. New balance: $%0d", amount, balance);
      return 1'b1; // Indicate successful withdrawal
    end else begin
      $display("Withdrawal failed. Insufficient funds or invalid amount.");
      return 1'b0; // Indicate failed withdrawal
    end
  endfunction : withdraw

  // Public method: to get the current balance (read-only access)
  function int getBalance();
    return balance; // Return the value of the private 'balance' property
  endfunction : getBalance

endclass : BankAccount

module encapsulation_example_module;
  initial begin
    BankAccount account = new(); // Create a BankAccount object

    account.deposit(100);       // Deposit $100 using the public 'deposit()' method
    account.deposit(50);        // Deposit another $50

    $display("Current Balance: $%0d", account.getBalance()); // Get and display balance using public 'getBalance()' method
    // Output: Current Balance: $150

    if (account.withdraw(200)) begin // Attempt to withdraw $200 - should fail due to insufficient funds
      $display("Withdrawal successful (unexpected!)"); // This line should NOT be reached
    end else begin
      $display("Withdrawal failed as expected."); // This line WILL be reached
    end

    if (account.withdraw(75)) begin  // Attempt to withdraw $75 - should succeed
      $display("Withdrawal of $75 successful."); // This line WILL be reached
    end

    $display("Final Balance: $%0d", account.getBalance()); // Get and display final balance
    // Output: Final Balance: $75

    // account.balance = 5000; // Error! Illegal access - 'balance' is declared 'local' (private)
                               // Cannot directly access or modify 'local' members from outside the class.
  end
endmodule : encapsulation_example_module
```

In this encapsulation example:

*   `local int balance;` declares `balance` as a `local` property, making it private to the `BankAccount` class.  Direct access to `balance` from outside the class (e.g., `account.balance = 5000;`) is illegal and will result in a compilation error.
*   `deposit()`, `withdraw()`, and `getBalance()` are public methods that provide *controlled access* to the `balance` property.  These methods define the *public interface* of the `BankAccount` class.
*   `deposit()` and `withdraw()` methods encapsulate the logic for modifying the balance, including validation (e.g., positive deposit amount, sufficient funds for withdrawal). This ensures that the balance is always modified in a controlled and valid way, protecting data integrity.
*   `getBalance()` provides read-only access to the `balance`, allowing external code to query the balance without being able to directly change it.

## Randomization within Classes:  Constrained Random Stimulus Generation

Classes are the foundation for randomization in SystemVerilog verification.  You can declare properties within a class as `rand` or `randc` to make them randomizable.  Constraints, defined using `constraint` blocks within the class, are used to specify the rules and restrictions for the random values generated for these `rand` variables.

### Example: Random Packet Generation with Constraints

```SV
class Packet;
  rand bit [7:0] address;   // Randomizable address property
  rand bit [7:0] data_byte; // Randomizable data byte property
  rand bit [3:0] size;      // Randomizable size property

  // Constraint block: 'address_range_constraint'
  constraint address_range_constraint {
    address inside {[8'h00 : 8'hFF]}; // 'address' must be within the range 0x00 to 0xFF (inclusive)
  }

  // Constraint block: 'valid_size_constraint'
  constraint valid_size_constraint {
    size inside {[1:8]}; // 'size' must be between 1 and 8 (inclusive)
  }

  // Constraint block: 'even_address_constraint'
  constraint even_address_constraint {
    (address % 2) == 0;  // 'address' must be an even number (divisible by 2)
  }

  function void display_packet();
    $display("Randomized Packet - Address: %h, Data: %h, Size: %0d", address, data_byte, size);
  endfunction : display_packet

endclass : Packet

module randomization_example_module;
  initial begin
    Packet packet_obj = new(); // Create a Packet object

    repeat (10) begin // Generate and randomize 10 packets
      if (packet_obj.randomize()) begin // Call randomize() method and check for success
        packet_obj.display_packet(); // Display the randomized packet properties
      end else begin
        $display("Randomization failed for Packet object!"); // Error message if randomization fails (constraints unsatisfiable)
      end
    end
  end
endmodule : randomization_example_module
```

In this randomization example:

*   `rand bit [7:0] address;`, `rand bit [7:0] data_byte;`, and `rand bit [3:0] size;` declare these properties as `rand`, making them randomizable.
*   `constraint address_range_constraint { ... }`, `constraint valid_size_constraint { ... }`, and `constraint even_address_constraint { ... }` define three constraint blocks that specify rules for the random values.
    *   `address inside {[8'h00 : 8'hFF]};` is a *range constraint*, limiting `address` to be between 0x00 and 0xFF.
    *   `size inside {[1:8]};` is another range constraint, limiting `size` to be between 1 and 8.
    *   `(address % 2) == 0;` is a *relational constraint*, ensuring that `address` is always an even number.
*   `if (packet_obj.randomize()) ... else ...` calls the `randomize()` method on the `packet_obj`. The `randomize()` method attempts to find random values for `address`, `data_byte`, and `size` that satisfy all the defined constraints. It returns 1 if successful and 0 if it fails (constraints are conflicting or unsatisfiable).
*   `packet_obj.display_packet();` displays the randomized values if randomization is successful.

## Exercises to Practice SystemVerilog Classes and OOP

1.  **Basic `Car` Class**:

    *   Create a SystemVerilog class named `Car`.
    *   Add the following *public* properties:
        - `string model;` (to store the car model name)
        - `int speed;` (to store the current speed of the car, initially 0)
    *   Implement a *public* method `function void accelerate();` that increases the `speed` property of the `Car` object by 10.
    *   In a module, instantiate a `Car` object, set its `model` property to "Sedan", call the `accelerate()` method twice, and then display the final `speed` of the car.

2.  **Object Usage and Interaction**:

    *   Extend the `Car` class from Exercise 1.
    *   Add a new *public* method `function void brake(int decrement);` to the `Car` class that decreases the `speed` by the amount specified by the `decrement` argument. Ensure that the speed does not become negative (clamp it at 0 if necessary).
    *   In a module, create two `Car` objects, set their `model` names, accelerate both of them, then apply `brake()` to only one of them. Display the `model` and `speed` of both cars to demonstrate independent object behavior.

3.  **Inheritance: `ElectricCar` Derived Class**:

    *   Create a new class `ElectricCar` that *inherits* from the `Car` class (Exercise 1).
    *   *Override* the `accelerate()` method in the `ElectricCar` class so that it increases the `speed` by 20 instead of 10 (as in the base `Car` class).  Inside the overridden `accelerate()` method of `ElectricCar`, you can optionally call `super.accelerate()` to also execute the base class's acceleration behavior *before* adding the electric car specific acceleration.
    *   In a module, create objects of both `Car` and `ElectricCar` classes. Call the `accelerate()` method on both objects and display their speeds to demonstrate that the overridden method in `ElectricCar` is executed.

4.  **Polymorphism: Virtual `start_engine()` Method**:

    *   Add a new *virtual* method `virtual function void start_engine();` to the base `Car` class. In the base class implementation, make it display a message like `"Generic engine started"`.
    *   *Override* the `start_engine()` method in the `ElectricCar` class to display a message like `"Electric engine started silently"`.
    *   In a module, declare a handle of type `Car`. Create objects of both `Car` and `ElectricCar` classes. Assign the `ElectricCar` object to the `Car` handle. Call the `start_engine()` method using the `Car` handle. Demonstrate that the `ElectricCar`'s `start_engine()` method is executed (dynamic dispatch).  Also, create a `Car` object and call `start_engine()` on it directly to show that the base class method is executed in that case.

5.  **Encapsulation: Private `speed` and Access Methods**:

    *   Modify the `Car` class (from Exercise 1 or 3) to make the `speed` property `local` (private).
    *   Add two *public* methods:
        - `function int getSpeed();` that returns the current value of the `speed` property.
        - `function void setSpeed(int new_speed);` that allows setting the `speed` property to a new value, but only if the `new_speed` is not negative (add a check to prevent negative speeds). If the `new_speed` is negative, display an error message and do not update the speed.
    *   In a module, create a `Car` object. Try to directly access and modify the `speed` property (this should result in a compilation error, demonstrating encapsulation). Use the `setSpeed()` method to set the speed to a valid value, then use `getSpeed()` to retrieve and display the speed, demonstrating controlled access through public methods. Also, try to use `setSpeed()` to set a negative speed and observe the error message and that the speed is not updated.

6.  **Randomization: `Transaction` Class with Constraints**:

    *   Create a class named `Transaction`.
    *   Add the following *random* properties (`rand` keyword):
        - `rand bit [31:0] address;`
        - `rand bit [7:0] data;`
    *   Add *constraint blocks* to the `Transaction` class to define the following constraints:
        - `address` should be within the range `[0x1000 : 0x8000]` (inclusive).
        - `data` should be an even number and within the range `[0 : 254]` (inclusive).  You'll need two separate constraints or combine them appropriately.
    *   In a module, create a `Transaction` object.  In a loop that iterates 10 times, call `randomize()` on the `Transaction` object.  After each successful randomization, display the randomized values of `address` and `data`.  Run the simulation and verify that all generated `address` and `data` values satisfy the defined constraints.

These exercises will provide a solid foundation in SystemVerilog classes and object-oriented programming concepts, essential for building advanced verification environments. They cover class definition, object instantiation, inheritance, polymorphism, encapsulation, and randomization, all within the context of SystemVerilog for hardware verification.

##### Copyright (c) 2026 ChipVerge

