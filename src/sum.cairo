%builtins output

from starkware.cairo.common.serialize import serialize_word 

func sum_three_nums(num1: felt, num2: felt, num3: felt) -> (sum: felt) {
alloc_locals;
local sum = num1 + num2 + num3;
return (sum=sum);
}

func main{output_ptr: felt*}() {  
alloc_locals; 

const NUM1 = 1;
const NUM2 = 115;
const NUM3 = 15;
let (sum) = sum_three_nums(num1=NUM1, num2=NUM2, num3=NUM3);
serialize_word(sum);
return ();
}



