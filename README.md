# CS305 - Programming Languages (Spring 2024-2025)

This repository contains my complete solutions to the homework assignments for **CS305 - Programming Languages** at Sabancı University.  
The course covers fundamental and advanced concepts in the design and implementation of programming languages, providing both theoretical background and hands-on experience.

Through these projects, I developed components of a domain-specific language, built a semantic analyzer, practiced functional programming with Scheme, and implemented a working interpreter for a Scheme subset.

---

## 📚 Course Topics

- **Syntax and semantics of programming languages**
- **Lexical analysis (scanning)** using Flex
- **Syntax analysis (parsing)** with Bison
- **Semantic analysis and attribute grammars**
- **Functional programming in Scheme**
- **Logic programming basics**
- **Interpreter design and implementation**
- **Introduction to parallel programming models**

---

## 📝 Homework Assignments

### HW1: Lexical Analyzer (Scanner) for Meeting Scheduler (MS)

- **Goal:** Design a lexical analyzer for the custom MS scripting language using **Flex**.
- **Key features:**
  - Recognizes MS language tokens (e.g. `Meeting`, `endMeeting`, `startDate`, `startTime`, identifiers, integers, dates `DD.MM.YYYY`, times `HH.MM`, strings, operators `=`, `,`).
  - Handles both single-line (`//`) and nested multiline (`/* ... */`) comments.
  - Tracks and reports line positions for each token.
  - Detects illegal characters and reports meaningful error messages without crashing.
- **Output:** For each token, outputs its type and position in a strict format suitable for automated testing.

---

### HW2: Syntax Analyzer (Parser) for MS

- **Goal:** Define a **Bison** grammar for MS and implement a parser enforcing syntactic correctness.
- **Key features:**
  - Enforces grammar rules for meeting blocks, including required elements (`meetingNumber`, `description`, `startDate`, `startTime`, `endDate`, `endTime`, `locations`, `isRecurring`).
  - Supports optional elements (`frequency`, `repetitionCount`, `subMeetings`) with strict ordering constraints.
  - Handles arbitrarily nested `subMeetings`, creating recursive structures.
  - Rejects programs that violate element order, required/optional constraints, or nesting rules.

---

### HW3: Semantic Analyzer & Translator for MS

- **Goal:** Extend the parser to include semantic checks and translate recurring meetings.
- **Key semantic checks implemented:**
  - Validate date ranges (`01.01.2025` to `28.12.2050`) and time ranges (`00.00` to `23.59`).
  - Ensure meeting end times are after start times (including cross-date validation).
  - Verify sub-meetings are within the temporal and spatial bounds of their parent meeting.
  - Ensure no duplicate `meetingNumber`s across all meetings and sub-meetings.
  - Validate that sub-meetings do not repeat and do not introduce new locations not listed by the parent.
  - Enforce proper recurrence structure (frequency and repetitionCount correctness).
- **Translation:** Automatically expands recurring meetings into explicit repeated instances, adjusting dates accordingly.

---

### HW4: Functional Programming in Scheme - Sequence Processing

- **Goal:** Gain fluency in Scheme by implementing sequence operations and predicate functions.
- **Key functions implemented:**
  - `sequence?` – Validates that input is a list of single-character symbols.
  - `same-sequence?`, `reverse-sequence` – Tests equality and reverses sequences.
  - `palindrome?`, `anagram?`, `anapoli?` – Detects palindromes, anagrams, and anapoli (anagram of a palindrome).
  - `member?`, `remove-member`, `unique-symbols`, `count-occurrences` – Symbol and sequence utilities.
- **Error handling:** All functions print error messages in a custom format (`ERROR305: ...`) rather than crashing.

---

### HW5: Scheme (s7) Interpreter

- **Goal:** Build an interpreter (REPL) for a **Scheme subset (s7)** supporting arithmetic and functional constructs.
- **Supported features:**
  - Variable bindings via `define`
  - Lexically scoped variable bindings via `let`
  - Anonymous functions via `lambda`
  - Arithmetic expressions with `+`, `-`, `*`, `/` (left associative for `-` and `/`)
  - Direct lambda applications and bound lambda calls
- **Behavior:**
  - Checks syntax and arity of expressions before evaluation.
  - Outputs evaluated results or displays clear error messages.
  - Returns to the REPL prompt after errors without terminating the interpreter session.

---

## ⚙️ Technologies & Tools

- **Flex**: Lexical analyzer generator (scanner)
- **Bison**: Parser generator (syntax and semantic analyzer)
- **C / C++**: Integration of scanner, parser, and semantic logic
- **Scheme (R5RS)**: Functional programming assignments and interpreter implementation
- **MIT Scheme / Racket / Guile**: Compatible interpreters for testing Scheme assignments

---

## 🚀 How to Run

Run the following commands in a terminal and Scheme interpreter:

```bash
# Compile and run HW1-HW3 (Flex + Bison + GCC)
flex ms.l && \
bison -d ms.y && \
gcc lex.yy.c ms.tab.c -o ms_parser -lfl && \
./ms_parser < input.ms

# For HW4 or HW5 (Scheme)
# Open your Scheme interpreter (e.g., mit-scheme) and run:
# (load "your_username-hw4.scm")  ; or (load "your_username-hw5.scm")
# (cs305)                         ; start interpreter for HW5
# ; For HW4, call specific functions, e.g., (palindrome? '(a b a))

