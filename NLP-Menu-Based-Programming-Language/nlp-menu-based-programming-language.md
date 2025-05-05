# Report on G-ALYCE: Guided (by LLM) All You Can Eat Menu Based Programming Language


## Design Goals

The primary design goals for this programming language are driven by fundamental software engineering principles:

- **Readability:** Ensuring clear and intuitive syntax, supported by consistent and minimalistic language features.
- **Writability:** Simplified through LLM assistance, allowing users to quickly define and modify code.
- **Reliability:** Enhanced by optional static typing, rigorous compile-time checks, and adaptive runtime safeguards.
- **Cost:** Reduced via minimized debugging and faster development cycles due to intelligent feature recommendations.
- **High Functionality and Simplicity:** Balancing advanced programming capabilities with simplified language structures tailored to user needs.

## Targeted Domains

The language adapts well to multiple domains:

- **Business and Scientific:** Ideal for structured data handling and intensive computational tasks.
- **Educational:** Supports diverse programming paradigms that aid learners through progressive complexity.
- **Highly Secure and Computationally Intensive Tasks:** Robust security features and performance optimizations.

## Targeted Users

The language targets a diverse user base:

- **Domain Experts:** Enables non-experts to solve domain-specific problems without deep programming knowledge.
- **Students:** Adaptive features provide a graduated learning experience.
- **Professional Programmers:** Offers flexibility through dynamic configuration of paradigms and features.

## Type of Language

The language supports flexible execution and programming paradigms:

- **Compiled or Interpreted:** Chosen dynamically based on user needs.
- **Multi-Paradigm:** Procedural, object-oriented, functional, and logic paradigms are supported and guided by the LLM.
- **Adaptive:** Allows mid-code execution paradigm switching, guided by LLM suggestions to optimize for specific tasks dynamically during runtime.

## Unique Features

Key unique aspects of this language include:

- **LLM-Assisted Configuration:** Users interact with a centralized Large Language Model (LLM), maintained by language developers, to configure language features for specific tasks.
- **Dynamic Adaptability:** Automatically adjusts complexity levels and paradigms based on task requirements.
- **Feature Modularity:** Allows users to toggle language features, optimizing performance and resource usage.
- **LLM-Assisted Design:** The LLM actively advises when to change programming paradigms within code based on ongoing functionality, ensuring optimal paradigm use for clarity and efficiency.

## LLM Integration

The language utilizes a dedicated, **centralized LLM**, managed by the language creators. This ensures consistency, security, and reliability. Existing advanced models like GPT-4 can be fine-tuned specifically to meet the language's needs, ensuring domain-specific knowledge, rapid suggestions, and seamless integration with the language features.

New capabilities required by the LLM include:

- **Real-time context-awareness** of code execution.
- Ability to **suggest paradigm shifts dynamically**.
- **Enhanced error prediction** and **correction**.

The language-specific LLM provides suggestions and configuration help only. **For code generation, users must switch to a separate, general-purpose AI model**.

## Clarifying Readability with Multi-Paradigm Support using LLM Suggestions

To ensure readability despite supporting multiple programming paradigms, the language employs clearly defined syntax boundaries and explicit context markers when switching paradigms. The dedicated centralized LLM actively assists users by recommending optimal paradigms suited specifically to the task context. This guided approach reduces cognitive overhead for users, as code blocks explicitly indicate active features and intended paradigms, maintaining clarity even in highly adaptable codebases. This design ensures that even advanced functionality remains comprehensible.

## Centralized LLM and Reliability

The decision to implement a centralized LLM, maintained by the language developers, enhances the reliability and consistency of language use. By limiting the centralized LLM strictly to providing configuration and feature-use recommendations—rather than generating actual code—the risk of inconsistent or incorrect code generation is significantly minimized. Users can rely on this centralized, fine-tuned model to consistently enforce best practices and optimal paradigm selections, thereby inherently improving overall reliability and maintainability of user-written code.

## Separation of Concerns in AI Models

The separation between the dedicated centralized LLM (which guides paradigm usage and language features) and general-purpose AI models (which generate actual code) is intentional and strategic. This design choice ensures that each AI component focuses on what it does best, optimizing performance, responsiveness, and accuracy. Users obtain quick, reliable guidance from the dedicated language LLM and detailed, task-specific code from specialized external models as needed, ensuring efficient workflow management.

## Example Programs Demonstrating Features

### Example 1: Educational Context (Procedural Simplicity)

**Prompt:**
> "Teach basic loop structures to beginners."

**LLM Suggestion:**
```
Suggested features:
- Interpreted mode
- Procedural programming
```

**Code Example:**
```procedural
enable["interpreted_mode"]
enable["procedural_programming"]

for i in 1..5 {
    print("Iteration:", i)
}
```

### Example 2: Scientific Context (Functional Clarity and Reliability)

**Prompt:**
> "Perform statistical analysis on experimental data with precise error checks."

**LLM Suggestion:**
```
Suggested features:
- Compiled mode
- Functional programming
- Static typing
```

**Code Example:**
```functional
enable["compiled_mode"]
enable["functional_programming"]
enable["static_typing"]

func calculateMean(data: List<Float>) -> Float {
    validateData(data)
    return sum(data) / length(data)
}
```

### Example 3: Security Context (Adaptive Paradigm Switching)

**Prompt:**
> "Develop a secure user authentication module."

**LLM Initial Suggestion:**
```
Suggested initial features:
- Compiled mode
- Object-oriented programming
```


**Initial Code Example:**
```object-oriented
enable["compiled_mode"]
enable["object_oriented_programming"]

class UserAuth {
    private String username;
    private String hashedPassword;
}
```

**Mid-execution LLM Suggestion:**
```
Switch to Functional programming for cryptographic calculations.
```

**Code Example (After Switching):**
```functional
disable["object_oriented_programming"]
enable["functional_programming"]

let hashPassword(password: String) -> String = immutableHash(password)
```

### Example 4: Business Logic (Error Handling - Conflicting Modes)

**Prompt:**
> "I need both compiled and interpreted features simultaneously."

**LLM Suggestion:**
```
Error: Cannot enable both interpreted and compiled modes simultaneously. 
Choose one.
```

### Example 5: Educational Context (Warning - Syntax Conflict)

**Prompt:**
> "Calculate squares in procedural mode."

**LLM Suggestion:**
```
Suggested initial feautures:
-Interpreted Mode
-Procedural Programming
```

**Code Example:**
```functional
enable["interpreted_mode"]
enable["procedural_programming"]

let square(x) -> x * x
```

**LLM Suggestion:**
```
Warning: Functional syntax detected in procedural mode. 
Enable functional programming or use procedural syntax 
for better program behavior and error predictions.
```

### Example 6: Paradigm Switching Error

**Prompt:**
> "Switch directly from procedural to object-oriented mid-block."

```config
enable["procedural_programming"]
```

**Mid-execution LLM Suggestion:**
```
Switch to object-oriented programming now.
```

**Code Example (Attempted Direct Switch):**
```object-oriented
enable["object_oriented_programming"]

class Counter {
    int count;
}
```

**LLM Suggestion:**
```
Error: Enabling two paradigms at the same time is now allowed. 
Disable "procedural_programming" before switching to 
"object_oriented programming" to allow OOP program execution.
```

## Additional Example: Ensuring Readability and Reliability through Explicit Markers

**Prompt:**  
> "Develop data processing routines that clearly separate functional transformations from procedural I/O operations."

**LLM Suggestion:**  
```
Suggested initial features:
- Interpreted mode
- Functional programming (for data transformations)
- Procedural programming (for I/O operations, separated by explicit markers)
```

**Code Example:**  
```config
enable["interpreted_mode"]
enable["functional_programming"]

// Functional transformation clearly marked
func transformData(data: List<Int>) -> List<Int> {
    return data.filter(x -> x > 0).map(x -> x * 2)
}

disable["functional_programming"]
enable["procedural_programming"]

// Procedural I/O operations explicitly marked
procedure saveData(transformedData: List<Int>) {
    for item in transformedData {
        writeToFile(item)
    }
}
```

This explicit marking and separation enhance readability and reliability by clearly indicating the intended purpose and paradigm of each code segment.

## Additional LLM Features Required for Robustness

To fully realize the adaptive and multi-paradigm nature of the language, the centralized LLM needs advanced contextual features, including:

- **Contextual history tracking:** Enables accurate and reliable paradigm shift suggestions based on previous decisions and current code context.
- **User intent inference:** Improved natural language understanding to accurately determine the user's intent and suggest optimal configurations dynamically.
- **Incremental code-context comprehension:** Ensures that paradigm shifts or feature adjustments suggested by the LLM are contextually valid, ensuring ongoing consistency in code readability and functionality.

## Considerations and Inspirations

The language aims to overcome traditional complexity by utilizing intelligent adaptability. Key considerations include:

- **Feature flexibility and modularity:** Ensuring features are modular and easily managed by users without losing language stability.
- **Syntax simplicity:** Balancing powerful capabilities with simplicity to maintain accessibility.
- **Paradigm integration:** Ensuring seamless switching between paradigms to maintain readability and reliability.

## Syntax Definition

Formally defined using Backus-Naur Form (BNF), key constructs include:
```
<program> ::= { <statement> }

<statement> ::= <declaration> | <function-call> | <if-then-else> | <loop> | <definition>

<declaration> ::= 'let' <identifier> ':' <type> '=' <expression>

<function-call> ::= <identifier> '(' [<expression-list>] ')'

<if-then-else> ::= 'if' <expression> 'then' <statement> ['else' <statement>]

<loop> ::= 'for' <identifier> 'in' <expression> '..' <expression> '{' {<statement>} '}'

<definition> ::= 'func' <identifier> '(' [<parameter-list>] ')' '->' 
                                            <type> '{' {<statement>} '}'
```

## Additional Syntax Definitions (Feature Configuration)

Formally defining the syntax for dynamically enabling or disabling language features:

```
<feature-config> ::= <enable-statement> | <disable-statement>

<enable-statement> ::= 'enable' '[' '"' <feature-name> '"' ']'

<disable-statement> ::= 'disable' '[' '"' <feature-name> '"' ']'

<feature-name> ::= "interpreted_mode" 
                 | "compiled_mode"
                 | "procedural_programming"
                 | "object_oriented_programming"
                 | "functional_programming"
                 | "static_typing"
                 | <other_feature_names_defined>
```

## Issues for Loop Designs

Critical loop considerations include:

- **Type and Scope:** Clearly defined and constrained loop variable scope.
- **Variable Modification:** Restrictions on modifying loop variables mid-execution.
- **Evaluation Frequency:** Loop parameters evaluated once for predictable performance.
- **Post-loop Variable State:** Defined and predictable post-loop states.

These ensure loops operate predictably and safely, supporting the language’s reliability goals.
