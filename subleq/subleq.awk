#!/usr/bin/gawk -f

function peek(address) {
    return memory[address]
}
function poke(value, address) {
    if( value != memory[address] ) {
        print "["address"] = "value
        memory[address] = value
    }
}

BEGIN {
    LINT="validate"
    memory[1] = 0
    a = 0
    b = 0
    c = 0
    program_counter = 1
    loadpointer = 1
}

/^ *#/ { print $0 }

!/^ *#/ {
    a = $1
    b = $2
    c = $3
    poke(a, loadpointer++)
    poke(b, loadpointer++)
    poke(c, loadpointer++)
}

 END {
    while (program_counter >= 1) {
        a = peek(program_counter)
        b = peek(program_counter+1)
        c = peek(program_counter+2)
        print "-> " program_counter, a, b ,c
        if (a < 0 || b < 0) {
            program_counter = 0 # Halt
        }
        else {
            poke(peek(b)- peek(a), b)
            if (peek(b) > 0) {
                program_counter += 3
            }
            else {
                program_counter = c
            }
        }
    }
}