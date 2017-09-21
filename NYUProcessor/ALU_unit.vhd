library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- for addition
use IEEE.NUMERIC_STD.ALL;

entity ALU_unit is 
	Port (
	  clk						:	IN STD_LOGIC;
	  rst 					:  IN STD_LOGIC;	--For HALT
	  decode_opcode		:	IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	  decode_rd	  			:	IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	  decode_rs1			:	IN STD_LOGIC_VECTOR(2 downto 0);
	  decode_rs2			:	IN STD_LOGIC_VECTOR(2 downto 0);
	  decode_tail			:	IN STD_LOGIC_VECTOR(2 downto 0);
	  pc_out					:	IN STD_LOGIC_VECTOR(7 downto 0);
	  data_out1 			:	IN STD_LOGIC_VECTOR(7 downto 0);
	  data_out2 			:	IN STD_LOGIC_VECTOR(7 downto 0);
	 
	  data_in				:	OUT STD_LOGIC_VECTOR(7 downto 0);
	  addr_Rs1				:	OUT STD_LOGIC_VECTOR(2 downto 0);
	  addr_Rs2				:	OUT STD_LOGIC_VECTOR(2 downto 0);
	  addr_Rd				:  OUT STD_LOGIC_VECTOR(2 downto 0);
	  Rd_we 					:  OUT STD_LOGIC; 
	  load_pc				:  OUT STD_LOGIC;
	  incr_pc 				:  OUT STD_LOGIC;
	  data_pc_in         :  OUT STD_LOGIC_VECTOR(7 downto 0)
   );
	
end ALU_unit;

architecture ALU_ARCHITECTURE of ALU_unit is 

	--ALU Temp Signal(s)
	signal immediate_offset	:  STD_LOGIC_VECTOR(7 downto 0);
	signal branch_offset : STD_LOGIC_VECTOR(7 downto 0);
	signal asynch_ram_index_jump : unsigned(7 downto 0);	--Amount of instructions between current instruction 
																			--and last instruction index
	signal immediate_offset_modulo_result : STD_LOGIC_VECTOR(7 downto 0);
	signal branch_offset_modulo_result : STD_LOGIC_VECTOR(7 downto 0);
	
	signal opcode : STD_LOGIC_VECTOR(3 downto 0);
	signal rs1 : STD_LOGIC_VECTOR(2 downto 0);
	signal rs2 : STD_LOGIC_VECTOR(2 downto 0);
	signal rd : STD_LOGIC_VECTOR(2 downto 0);
	signal tail : STD_LOGIC_VECTOR(2 downto 0);
	
begin 
	--ALU
	ALU_process: process (clk, rst, decode_opcode,decode_rs1,decode_rs2,decode_rd,decode_tail,data_out1,data_out2,pc_out)
		begin
		if rising_edge(clk) then
			opcode <= decode_opcode;
			rs1 <= decode_rs1;
			rs2 <= decode_rs2;
			rd <= decode_rd;
			tail <= decode_tail;
			
			--Send to reg_file
			addr_Rs1 <= decode_rs1;
			addr_Rs2 <= decode_rs2;
			addr_Rd <= decode_rd;
			
			immediate_offset <= "00" & decode_rs2 & decode_tail;	--JMP uses this as well
			branch_offset <= "00" & decode_rd & decode_tail;
			
			asynch_ram_index_jump <= 10 - unsigned(pc_out);	--unsigned(pc_out) is current index
			if(asynch_ram_index_jump > unsigned(immediate_offset)) then
				null;
			elsif(asynch_ram_index_jump < unsigned(immediate_offset)) then
				immediate_offset_modulo_result <= STD_LOGIC_VECTOR(((unsigned(immediate_offset) - asynch_ram_index_jump) mod 11) - 1);
			end if;
			
			if(asynch_ram_index_jump > unsigned(branch_offset)) then
				null;
			elsif(asynch_ram_index_jump < unsigned(branch_offset)) then
				branch_offset_modulo_result <= STD_LOGIC_VECTOR(((unsigned(branch_offset) - asynch_ram_index_jump) mod 11) - 1);
			end if;
			
			if(opcode = "0000") then
				--ADD
				data_in	<= data_out1 + data_out2;
				Rd_we <= '1';
				--incr_pc <= '1';
			elsif(opcode = "0001") then
				--ADDI
				data_in <= data_out1 + immediate_offset;
				Rd_we <= '1';
				--incr_pc <= '1';
			elsif(opcode = "0010") then
				--SUB
				Rd_we <= '1';
				data_in	<= data_out1 - data_out2;
				--incr_pc <= '1';
			elsif(opcode = "0011") then
				--SUBI
				Rd_we <= '1';
				data_in <= data_out1 - immediate_offset;
				--incr_pc <= '1';
			elsif(opcode = "0100") then
				--AND
				Rd_we <= '1';
				data_in <= data_out1 AND data_out2;
				--incr_pc <= '1';
			elsif(opcode = "0101") then
				--ANDI
				Rd_we <= '1';
				data_in <= data_out1 AND immediate_offset;
				--incr_pc <= '1';
			elsif(opcode = "0110") then
				--OR
				Rd_we <= '1';
				data_in <= data_out1 OR data_out2;
				--incr_pc <= '1';
			elsif(opcode = "0111") then
				--ORI
				Rd_we <= '1';
				data_in <= data_out1 OR immediate_offset;
				--incr_pc <= '1';
			elsif(opcode = "1000") then 
				--SHL
				Rd_we <= '1';
				if(decode_tail = "000") then 
					data_in <= data_out1(7 downto 0);
				elsif(decode_tail = "001") then
					data_in <= data_out1(7 downto 1) & "0";
				elsif(decode_tail = "010") then
					data_in <= data_out1(7 downto 2) & "00";
				elsif(decode_tail = "011") then
					data_in <= data_out1(7 downto 3) & "000";
				elsif(decode_tail = "100") then
					data_in <= data_out1(7 downto 4) & "0000";
				elsif(decode_tail = "101") then
					data_in <= data_out1(7 downto 5) & "00000";
				elsif(decode_tail = "110") then
					data_in <= data_out1(7 downto 6) & "000000";
				elsif(decode_tail = "111") then
					data_in <= data_out1(7) & "0000000";
				else
					data_in <= data_out1;
				end if;
				--incr_pc <= '1';
			elsif(opcode = "1001") then
				--SHR
				Rd_we <= '1';
				if(decode_tail = "000") then
					data_in <= data_out1(7 downto 0);
				elsif(decode_tail = "001") then
					data_in <= "0" & data_out1(6 downto 0);
				elsif(decode_tail = "010") then
					data_in <= "00" & data_out1(5 downto 0);
				elsif(decode_tail = "011") then
					data_in <= "000" & data_out1(4 downto 0);
				elsif(decode_tail = "100") then
					data_in <= "0000" & data_out1(3 downto 0);
				elsif(decode_tail = "101") then
					data_in <= "00000" & data_out1(2 downto 0);
				elsif(decode_tail = "110") then
					data_in <= "000000" & data_out1(1 downto 0);
				elsif(decode_tail = "111") then
					data_in <= "0000000" & data_out1(0);
				else 	
					data_in <= data_out1;
				end if;
				--incr_pc <= '1';
			elsif(opcode = "1010") then
				--HAL 
				incr_pc <= '0';
				--STOP DISPLAY
			elsif(opcode = "1011") then
				--UDIV
				data_in <= STD_LOGIC_VECTOR(unsigned(data_out1)/unsigned(data_out2));
			elsif(opcode = "1100") then
				--JMP
				load_pc <= '1';
				data_pc_in <= immediate_offset_modulo_result;
			elsif(opcode = "1101") then
				--BLT
				if (data_out1 < data_out2) then 
					load_pc <= '1';
					data_pc_in <= branch_offset_modulo_result;
				else
					--incr_pc <= '1';
				end if;
			elsif(opcode = "1110") then
				--BE
				if (data_out1 = data_out2) then
					load_pc <= '1';
					data_pc_in <= branch_offset_modulo_result;
				else
					--incr_pc <= '1';
				end if;
			elsif(opcode = "1111") then
				--BNE
				if (data_out1 /= data_out2) then
					load_pc <= '1';
					data_pc_in <= branch_offset_modulo_result;
				else
					--incr_pc <= '1';
				end if;
			end if;
		end if;
	end process ALU_process;
end ALU_ARCHITECTURE;