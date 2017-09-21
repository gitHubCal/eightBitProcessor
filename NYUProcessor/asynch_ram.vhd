----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:42:00 03/27/2015 
-- Design Name: 
-- Module Name:    asynch_ram - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity asynch_ram is
    Port ( 
			  read_address : in  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (15 downto 0)
			);
end asynch_ram;

architecture Behavioral of asynch_ram is
   type ram_type is array (0 to 255) of std_logic_vector(15 downto 0);
   signal ram : ram_type;
	
	begin
	data_out <= ram (to_integer(unsigned(read_address)));
	ram_process: process (clk,rst)
		begin
	   if rising_edge(clk) then
			if rst = '1' then 
				ram (0)  <="0001101000000000";	--1A00
				ram (1)  <="0001100000000001";	--1801			
				ram (2)  <="0001011000000100";	--1604
				ram (3)  <="0001001000000001";	--1201
				ram (4)  <="0001010000000000";	--1400
				ram (5)  <="0000010100010000";	--0510
				ram (6)  <="1111111010011111";	--FE9F
				ram (7)  <="0000001100001000";	--0308
				ram (8)  <="0100001100001000";	--4308
				ram (9)  <="1111111001011011";	--FE5B
				ram (10) <="1010000000000000";	--5000
		
				--ram (0) <= x"0e50"; -- Rs7 = Rs1 + Rs2 = 0000_111_001_010_xxx
				--ram (1) <= x"C00E";
				--ram (2) <= x"0250";
				--ram (3) <= x"0250";
				--ram (4) <= x"0250";
				--ram (5) <= x"C00F"; -- JMP to 15
				
				--ram (5) <= x"A000"; -- HALT
				
	--			ram (15) <= x"0e50";--
	--			ram (16) <= x"C03F"; -- JMP back to 0 + PC ... means this same location
			end if; 
		end if; 	
	end process; 	
end Behavioral;	