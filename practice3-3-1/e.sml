fun multiplying x 0.0 : real = 1.0 
  | multiplying x i : real = x * multiplying (x, i-1.0)
