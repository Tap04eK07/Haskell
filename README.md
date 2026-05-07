A functional program for analyzing product sales data (name, quantity, price)

Requirements
Compiler:** GHC (Glasgow Haskell Compiler)
Language version:** Haskell2010 or later

Installation & Launch:
  1. Compile the program:
     ghc -o sales Main.hs
   
  2.Run the executable:
    Main.exe

Usage & Example:
  The program uses a console menu for data processing.

Input file format (data.txt):
  Apples,50,2.5
  bananas,30,3.0
  Cherries,10,15.5
  Dates,5,20.0

Key Operations:
Total Revenue: Calculates the sum of all sales
Filtering: Lists items with revenue above a specific threshold
Analytics: Finds the most and least profitable products

### Project Structure
Sale: Data type for records
totalRevenue: Pure function for sum calculation
