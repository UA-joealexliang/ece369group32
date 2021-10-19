Create task lists here

* [ ] make Hi_in Lo_in feed into ALU32Bit
* [ ] there should be 2 muxes for PC Counter
  -first one takes in PC+4 and PC+4+offset,  choice is determined by AND Gate {branch, Zero}
  -second one takes in result of first one and  immediate/register value, choice is determined by jump control
* [ ] update controller and datapath to support movn, movz
  -RegWrite = 0 for movn, movz; writing is determined by OR Gate {RegWrite, RegWrite2}
* [ ] support j, jr, jal
  -jr takes in rs or 25-21; need another mux to   choose between immediate and register value
  -jal updates register 31 with PC+4; need   another mux
* [✔] modify DataMemory to work with all loads & stores, need to add another controller signal, and add SignExtend
  -sh, lh only modifies 16 bits
  -sb, lb only modifes 8 bits
  -lh, lb need to be sign-extended before placed into Write (Joe implemented this into DataMemory file)
  -CONTROLLER SIGNAL ADDED: Datatype
* [ ] Load InstructionMemory.txt from file instead of hardcoding into module
* [ ] Input funct codes into ALU
