// Camlock piece (male), centered on the Z axis.
module camlock() {
  translate(v = [0, 0, -2.99]) 
  import(file = "./camlock_male.stl");
}

function camlock_dims() = [20, 26.25, 38];

camlock();