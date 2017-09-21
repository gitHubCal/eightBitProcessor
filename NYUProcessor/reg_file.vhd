----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:57:57 03/27/2015 
-- Design Name: 
-- Module Name:    reg_file - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_file is
    Port ( 
			  Addr_Rs1 : in  STD_LOGIC_VECTOR (2 downto 0);
           Addr_Rs2 : in  STD_LOGIC_VECTOR (2 downto 0);
           Addr_Rd : in  STD_LOGIC_VECTOR (2 downto 0);
			  Rd_we : in STD_LOGIC;  
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           data_out1 : out  STD_LOGIC_VECTOR (7 downto 0);
           data_out2 : out  STD_LOGIC_VECTOR (7 downto 0);
			  reg0 : out STD_LOGIC_VECTOR (7 downto 0);
			  reg1 : out STD_LOGIC_VECTOR (7 downto 0);
			  reg2 : out STD_LOGIC_VECTOR (7 downto 0);
			  reg3 : out STD_LOGIC_VECTOR (7 downto 0);
			  reg4 : out STD_LOGIC_VECTOR (7 downto 0);
			  reg5 : out STD_LOGIC_VECTOR (7 downto 0);
			  reg6 : out STD_LOGIC_VECTOR (7 downto 0);
			  reg7 : out STD_LOGIC_VECTOR (7 downto 0)
			 );
end reg_file;

architecture Behavioral of reg_file is

	type ram_type is array (0 to 7) of std_logic_vector(7 downto 0);
   signal ram : ram_type;
	
	begin
	data_out1 <= ram (to_integer(unsigned(Addr_Rs1))); 
	data_out2 <= ram (to_integer(unsigned(Addr_Rs2))); 
	
	ram_process: process (clk, rst)
		begin
	   if rising_edge(clk) then
			if rst = '1' then 
				--for i in 0 to 255 loop 
					--ram (i) <= (others => '0'); 
				--end loop; 
				ram (0) <= x"00"; -- 
				--ram (1) <= x"08";
				--ram (2) <= "01000000"; --x"64";
				ram (1) <= x"00";
				ram (2) <= x"00";
				ram (3) <= x"00";
				ram (4) <= x"00";
				ram (5) <= x"00";
				ram (6) <= x"00";
				ram (7) <= x"00";
			elsif (Rd_we = '1') then 
				ram (to_integer(unsigned(Addr_Rd))) <= data_in;  
			end if; 
			 reg0 <= ram(0);
			 reg1 <= ram(1);
			 reg2 <= ram(2);
			 reg3 <= ram(3);
			 reg4 <= ram(4);
			 reg5 <= ram(5);
			 reg6 <= ram(6);
			 reg7 <= ram(7);
		end if; 	
	end process; 

end Behavioral;