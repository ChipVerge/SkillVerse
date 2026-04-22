# Chapter 2: Dive into Formal Methods Basics

## Mathematical Logic
Mathematical logic is the foundation of formal methods. It involves the use of formal languages to represent logical statements and reasoning.

### Key Concepts:
- **Propositional Logic**: Logic dealing with propositions and their connectives.
  - **Example**: "If it rains, then the ground is wet" can be represented as R → W.
  - **Connectives**: AND (∧), OR (∨), NOT (¬), IMPLIES (→)
- **Predicate Logic**: Extends propositional logic with quantifiers and predicates.
  - **Example**: "All humans are mortal" can be represented as ∀x (Human(x) → Mortal(x)).
  - **Quantifiers**: Universal (∀), Existential (∃)
- **Proof Techniques**: Methods to prove logical statements.
  - **Direct Proof**: Proving a statement by straightforward logical steps.
    - **Example**: Proving that if n is even, then n^2 is even.
  - **Proof by Contradiction**: Assuming the opposite of what you want to prove and showing it leads to a contradiction.
    - **Example**: Proving that √2 is irrational by assuming it is rational and deriving a contradiction.

## Temporal Logic
Temporal logic is used to reason about sequences of events in time, which is crucial for verifying the behavior of systems over time.

### Key Concepts:
- **Linear Temporal Logic (LTL)**: Focuses on linear sequences of states.
  - **Example**: "Eventually, the system will reach a safe state" can be represented as F Safe.
  - **Operators**: Always (G), Eventually (F), Next (X), Until (U)
- **Computation Tree Logic (CTL)**: Deals with branching time structures.
  - **Example**: "There exists a path where the system always remains safe" can be represented as E G Safe.
  - **Operators**: Exists (E), For All (A), Next (X), Until (U)
- **Temporal Operators**: Used to describe sequences of events.
  - **Always (G)**: A condition that must always be true.
  - **Eventually (F)**: A condition that must eventually be true.
  - **Next (X)**: A condition that must be true in the next state.
  - **Until (U)**: A condition that must be true until another condition becomes true.

##### Copyright (c) 2026 ChipVerge

