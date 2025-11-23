// Model found on Printables, see <https://www.printables.com/model/513831-ferris-sweep-22-case>
module simple() {
  translate(v=[-200, -40, 2])
    import(file="./simple.stl");
}

module magnetic() {
  translate(v=[-60, 50, 0])
    import(file="./magnetic.stl");
}
