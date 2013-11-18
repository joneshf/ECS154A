module alu( input logic [15:0] a, b, // operands
				input logic [3:0] s, // operation selectors
				output logic [15:0] r, // result
				output logic c, z, n, o); // flag outputs: carry, zero, negative, overflow
	/*
	The operation selector bit breakdown:
	MSB of instruction is always 0, so we take the 4 low bits directly.
	ADD:  0 0 0 0 0
	SUB:  0 0 0 0 1
	ADDI: 0 0 0 1 0
	AND:  0 0 0 1 1
	OR:   0 0 1 0 0
	XOR:  0 0 1 0 1
	NOT:  0 0 1 1 0
	INV:  0 0 1 1 1
	ROR:  0 1 0 0 0
	ROL:  0 1 0 0 1
	SHR:  0 1 0 1 0
	SHL:  0 1 0 1 1
	
	Values between 01011 and 10000 (not inclusive) are garbage values.
	For the ROR and ROL instructions to have access to carry flag,
	we copy these into the b operand and access the lowest bit.
	*/
	
	// intermediary results
	logic [15:0] add, sub, addi, anda, ora, xora, nota, inv, ror, rol, shr, shl;
	// hold the carry flags
	logic addc, subc, addic, rorc, rolc, shrc, shlc;
	// hold the overflows
	logic addo, subo, addio;
	// n and z are set based on r
	// for add operations that don't set carry or overflow
	logic trash1, trash2;
	
	// do the maths
	add_sixteen adder(a, b, 1'b0, add, addc, addo);
	add_sixteen adder2(a, ~b, 1'b1, sub, subc, subo);
	add_sixteen adder3(a, b, 1'b0, addi, addic, addio);
	and_sixteen ander(a, b, anda);
	
	or_sixteen orer(a, b, ora);
	xor_sixteen xorer(a, b, xora);
	not_sixteen noter(a, nota);
	add_sixteen adder4(~a, 16'b0, 1'b1, inv, trash1, trash2);
	
	ror_sixteen rorer(a, b[0], ror, rorc);
	rol_sixteen roler(a, b[0], rol, rolc);
	shr_sixteen shrer(a, shr, shrc);
	shl_sixteen shler(a, shl, shlc);
	
	always_comb
		begin
		// to avoid inferring a latch for unused variables
		// the controller will need to only set these values if they should be set.
		o = 1'b0;
		c = 1'b0;
		n = 1'b0;
		z = 1'b0;
		case(s)
			4'b0000:
				begin
					r = add;
					c = addc;
					o = addo;
				end
			4'b0001:
				begin
					r = sub;
					c = subc;
					o = subo; 
				end
			4'b0010:
				begin
					r = addi;
					c = addic;
					o = addio;
				end
			4'b0011: r = anda;
			4'b0100: r = ora;
			4'b0101: r = xora;
			4'b0110: r = nota;
			4'b0111: r = inv;
			4'b1000:
				begin
					r = ror;
					c = rorc;
				end
			4'b1001:
				begin
					r = rol;
					c = rolc;
				end
			4'b1010:
				begin
					r = shr;
					c = shrc;
				end
			4'b1011:
				begin
					r = shl;
					c = shlc;
				end
			default: r = 16'b0;
		endcase
		// set the n and z flags once the result has been calculated.
		casez(r)
			16'b1???????????????: n = 1'b1;
			16'b0: z = 1'b1;
			default:
				begin
					n = 1'b0;
					z = 1'b0;
				end
		endcase
	end
		
endmodule
