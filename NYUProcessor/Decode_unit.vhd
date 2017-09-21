library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- for addition
use IEEE.NUMERIC_STD.ALL;

entity Decode_unit is 
	Port (
	  clk						:	IN STD_LOGIC;
	  pc_out 				:  IN STD_LOGIC_VECTOR(7 downto 0);
	  data_out 				:  IN STD_LOGIC_VECTOR(15 downto 0);
	  decode_opcode		:	OUT STD_LOGIC_VECTOR(3 downto 0);
	  decode_rd	  			:	OUT STD_LOGIC_VECTOR(2 downto 0);
	  decode_rs1			:	OUT STD_LOGIC_VECTOR(2 downto 0);
	  decode_rs2			:	OUT STD_LOGIC_VECTOR(2 downto 0);
	  decode_tail			:	OUT STD_LOGIC_VECTOR(2 downto 0)
	);
	
end Decode_unit;

architecture Decoder_ARCHITECTURE of Decode_unit is 

begin
	--DECODE_UNIT
	DECODE_UNIT_process: process (clk,data_out) 
		begin
		if rising_edge(clk) then 
			decode_opcode <= data_out(15 downto 12);
			decode_rd <= data_out(11 downto 9);
			decode_rs1 <= data_out(8 downto 6);
			decode_rs2 <= data_out(5 downto 3);
			decode_tail <= data_out(2 downto 0);
		end if;
	end process DECODE_UNIT_process; 
end Decoder_ARCHITECTURE;