----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:16:15 03/27/2015 
-- Design Name: 
-- Module Name:    PC_reg - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- for addition

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC_reg is
    Port ( 
			  inp : in  STD_LOGIC;
           incr_pc : in  STD_LOGIC;
			  load_pc : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           --clk : in  STD_LOGIC;
			  data_pc_in: in  STD_LOGIC_VECTOR (7 downto 0);
           pc_out : out  STD_LOGIC_VECTOR (7 downto 0)
			);
end PC_reg;

architecture Behavioral of PC_reg is
	signal pc_reg: STD_LOGIC_VECTOR (7 downto 0);
	begin
		pc_out <= pc_reg;  
		pc_process: process (rst,inp,incr_pc,load_pc)
		begin  
			if (rst = '1') then
				pc_reg <= (others => '0'); 
			elsif (inp = '1' or incr_pc = '1') then 
				pc_reg <= pc_reg + 1; 
			--elsif (inp = '0' or incr_pc = '0') then 
				--pc_reg <= pc_reg;
			elsif (load_pc = '1') then 	
				pc_reg <= data_pc_in; 
			else 
				pc_reg <= pc_reg;
			end if; 	
		end process pc_process; 
end Behavioral;