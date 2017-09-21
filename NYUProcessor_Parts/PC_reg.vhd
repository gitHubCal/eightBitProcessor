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
    Port ( inp : in  STD_LOGIC_VECTOR (7 downto 0);
           incr_pc : in  STD_LOGIC;
			  load_pc : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  data_pc_in: in  STD_LOGIC_VECTOR (7 downto 0);
           pc_out : out  STD_LOGIC_VECTOR (7 downto 0));
end PC_reg;

architecture Behavioral of PC_reg is
	signal pc_reg: STD_LOGIC_VECTOR (7 downto 0);
	begin
		pc_out <= pc_reg;  
		pc_process: process (clk, rst)
		begin 
			if (clk'event and clk = '1') then
				if (rst = '1') then
					pc_reg <= (others => '0'); 
				elsif (load_pc = '1') then 	
					pc_reg <= data_pc_in; 
				elsif (incr_pc = '1') then 
					pc_reg <= pc_reg + 1; 
				end if;
			end if; 	
---			end if; 
		end process pc_process; 
	
end Behavioral;

