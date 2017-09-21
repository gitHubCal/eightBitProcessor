library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- for addition
use IEEE.NUMERIC_STD.ALL;

entity NYU_PROCESSOR is 
	Port ( 
	  clk : in  STD_LOGIC;
	  reset : in  STD_LOGIC;
	  instruction_display : in STD_LOGIC;
	  reg_file_display : in STD_LOGIC;
	  switch : in STD_LOGIC_VECTOR (15 downto 0);
     ca_output : out STD_LOGIC_VECTOR (6 downto 0);
	  an_output : out STD_LOGIC_VECTOR (7 downto 0)
	);
end NYU_PROCESSOR;

architecture PROCESSOR_ARCHITECTURE of NYU_PROCESSOR is 
	component PC_reg
	 port (
			  inp : in  STD_LOGIC;
           incr_pc : in  STD_LOGIC;
			  load_pc : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           --clk : in  STD_LOGIC;
			  data_pc_in: in  STD_LOGIC_VECTOR (7 downto 0);
           pc_out : out  STD_LOGIC_VECTOR (7 downto 0)
			);
	end component;
	
	component asynch_ram
	 port (
			  read_address : in  STD_LOGIC_VECTOR (7 downto 0);
           clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
           data_out 		: out  STD_LOGIC_VECTOR (15 downto 0)
			);
	end component;
	
	component reg_file 
	 port (
	        Addr_Rs1  : in  STD_LOGIC_VECTOR (2 downto 0);
           Addr_Rs2  : in  STD_LOGIC_VECTOR (2 downto 0);
           Addr_Rd   : in  STD_LOGIC_VECTOR (2 downto 0);
			  Rd_we     : in STD_LOGIC;  
           clk       : in  STD_LOGIC;
           rst       : in  STD_LOGIC;
			  data_in   : in  STD_LOGIC_VECTOR (7 downto 0);
           data_out1 : out  STD_LOGIC_VECTOR (7 downto 0);
           data_out2 : out  STD_LOGIC_VECTOR (7 downto 0);
			  reg0 		: out STD_LOGIC_VECTOR (7 downto 0);
			  reg1 		: out STD_LOGIC_VECTOR (7 downto 0);
			  reg2 		: out STD_LOGIC_VECTOR (7 downto 0);
			  reg3 		: out STD_LOGIC_VECTOR (7 downto 0);
			  reg4 		: out STD_LOGIC_VECTOR (7 downto 0);
			  reg5 		: out STD_LOGIC_VECTOR (7 downto 0);
			  reg6 		: out STD_LOGIC_VECTOR (7 downto 0);
			  reg7 		: out STD_LOGIC_VECTOR (7 downto 0)
			 );
	end component;
	
	component Decode_unit
	 port (
			  clk						:	IN STD_LOGIC;
			  pc_out 				:  IN STD_LOGIC_VECTOR(7 downto 0);
			  data_out 				:  IN STD_LOGIC_VECTOR(15 downto 0);
			  decode_opcode		:	OUT STD_LOGIC_VECTOR(3 downto 0);
			  decode_rd	  			:	OUT STD_LOGIC_VECTOR(2 downto 0);
			  decode_rs1			:	OUT STD_LOGIC_VECTOR(2 downto 0);
			  decode_rs2			:	OUT STD_LOGIC_VECTOR(2 downto 0);
			  decode_tail			:	OUT STD_LOGIC_VECTOR(2 downto 0)
			 );
	end component;
	
	component ALU_unit
	 port (
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
	end component;

	signal PC_reg_pc_out : STD_LOGIC_VECTOR(7 downto 0);
	
	signal asynch_ram_data_out : STD_LOGIC_VECTOR(15 downto 0);
	
	signal reg_file_rs1_output : STD_LOGIC_VECTOR(7 downto 0);
	signal reg_file_rs2_output : STD_LOGIC_VECTOR(7 downto 0);
	signal reg0_output : STD_LOGIC_VECTOR(7 downto 0);
	signal reg1_output : STD_LOGIC_VECTOR(7 downto 0);
	signal reg2_output : STD_LOGIC_VECTOR(7 downto 0);
	signal reg3_output : STD_LOGIC_VECTOR(7 downto 0);
	signal reg4_output : STD_LOGIC_VECTOR(7 downto 0);
	signal reg5_output : STD_LOGIC_VECTOR(7 downto 0);
	signal reg6_output : STD_LOGIC_VECTOR(7 downto 0);
	signal reg7_output : STD_LOGIC_VECTOR(7 downto 0);
	
	signal DECODE_UNIT_decode_opcode_output : STD_LOGIC_VECTOR(3 downto 0);
	signal DECODE_UNIT_decode_rd_output : STD_LOGIC_VECTOR(2 downto 0); 
	signal DECODE_UNIT_decode_rs1_output : STD_LOGIC_VECTOR(2 downto 0);
	signal DECODE_UNIT_decode_rs2_output : STD_LOGIC_VECTOR(2 downto 0); 
	signal DECODE_UNIT_decode_tail_output : STD_LOGIC_VECTOR(2 downto 0);
	signal DECODE_UNIT_decode_repeat_amt_output : STD_LOGIC_VECTOR(11 downto 0);
	
	signal ALU_addr_rs1_output : STD_LOGIC_VECTOR(2 downto 0);
	signal ALU_addr_rs2_output : STD_LOGIC_VECTOR(2 downto 0);
	signal ALU_addr_rd_output : STD_LOGIC_VECTOR(2 downto 0);
	signal ALU_rd_we_output : STD_LOGIC;
	signal ALU_data_in_output : STD_LOGIC_VECTOR(7 downto 0); 
	signal ALU_load_pc_output : STD_LOGIC;
	signal ALU_incr_pc_output : STD_LOGIC;
	signal ALU_data_pc_in_output : STD_LOGIC_VECTOR(7 downto 0);
	
	--Signal Displays
	signal segment_digit : STD_LOGIC_VECTOR(3 downto 0);
	signal display_output : STD_LOGIC_VECTOR(31 downto 0);
	signal counter : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal anode_counter : STD_LOGIC_VECTOR(31 downto 0);
	
	--Input switch signals
	signal switch_incr_pc : STD_LOGIC;
	
	begin 
	PC_reg_component : PC_reg port map(
							  --clk     		=> clk, --Input
							  rst     		=> reset, --Input
							  inp			   => switch_incr_pc, 
							  incr_pc 		=> ALU_incr_pc_output, --Input
							  load_pc 		=> ALU_load_pc_output, --Input
							  data_pc_in   => ALU_data_pc_in_output, --Input
							  pc_out 		=> PC_reg_pc_out --Output
							 );
							 
	asynch_ram_component : asynch_ram port map( 
									clk 			     => clk, --Input
									rst 			     => reset, --Input
									read_address     => PC_reg_pc_out, --Input
									data_out 	     => asynch_ram_data_out --Output
								  );
							 
	reg_file_component : reg_file port map(
								 --R0 is 0
								 clk       => clk, --Input
								 rst       => reset, --Input
								 Addr_Rs1  => ALU_addr_rs1_output, --Input
								 Addr_Rs2  => ALU_addr_rs2_output, --Input
								 Addr_Rd   => ALU_addr_rd_output, --Input
								 Rd_we 	  => ALU_rd_we_output, --Input	 
							    data_in   => ALU_data_in_output, --Input
							    data_out1 => reg_file_rs1_output, --Output 
							    data_out2 => reg_file_rs2_output, --Output
								 reg0 => reg0_output,
								 reg1 => reg1_output,
								 reg2 => reg2_output,
								 reg3 => reg3_output,
								 reg4 => reg4_output,
								 reg5 => reg5_output,
								 reg6 => reg6_output,
								 reg7 => reg7_output
								);
								
	DECODE_UNIT_component : Decode_unit port map(
									 clk           => clk, --Input
								    pc_out        => PC_reg_pc_out, --Input
								    data_out 		=>	asynch_ram_data_out, --Input
								    decode_opcode	=> DECODE_UNIT_decode_opcode_output, --Output
								    decode_rd	  	=>	DECODE_UNIT_decode_rd_output, --Output
								    decode_rs1		=>	DECODE_UNIT_decode_rs1_output, --Output
								    decode_rs2		=>	DECODE_UNIT_decode_rs2_output, --Output
								    decode_tail	=>	DECODE_UNIT_decode_tail_output --Output
									);
								
	ALU_component : ALU_unit port map(
						  clk 			 => clk, --Input
						  rst 			 => reset, --Input
						  decode_opcode => DECODE_UNIT_decode_opcode_output, --Input
						  decode_rd	    => DECODE_UNIT_decode_rd_output, --Input
						  decode_rs1	 => DECODE_UNIT_decode_rs1_output, --Input
						  decode_rs2	 => DECODE_UNIT_decode_rs2_output, --Input
						  decode_tail	 => DECODE_UNIT_decode_tail_output, --Input
						  pc_out			 => PC_reg_pc_out, --Input
						  data_out1 	 => reg_file_rs1_output, --Input
						  data_out2 	 => reg_file_rs2_output, --Input
						  addr_Rs1		 => ALU_addr_rs1_output, --Output
						  addr_Rs2		 => ALU_addr_rs2_output, --Output 		
						  addr_Rd		 => ALU_addr_rd_output, --Output	
						  Rd_we 			 => ALU_rd_we_output, --Output 	
						  data_in       => ALU_data_in_output, --Output
						  load_pc		 => ALU_load_pc_output, --Output	
						  incr_pc 		 => ALU_incr_pc_output, --Output
						  data_pc_in	 => ALU_data_pc_in_output --Output
						 );
						 
	display_process : process(switch(0)) 
	begin
		if(switch(0) = '1') then
			switch_incr_pc <= '1';
		elsif(switch(0) = '0') then
			switch_incr_pc <= '0';
		end if;
	end process display_process;
	--display_output <= "0000000000000000" & asynch_ram_data_out;

	--Select what to output
	--Asynchronous
	output_process : process(instruction_display,asynch_ram_data_out,display_output,
								reg_file_display,switch(1),switch(2),switch(3),switch(4),switch(5),switch(6),switch(7),switch(8),
								reg0_output,reg1_output,reg2_output,reg3_output,reg4_output,reg5_output,reg6_output,reg7_output)
	begin
		if(instruction_display = '1') then
			display_output <= "0000000000000000" & asynch_ram_data_out;
		elsif(reg_file_display = '1') then
			if(switch(1) = '1' and switch(2) = '0' and switch(3) = '0' and switch(4) = '0'
				and switch(5) = '0' and switch(6) = '0' and switch(7) = '0' and switch(8) = '0') then
				display_output <= "000000000000000000000000" & reg0_output;
			elsif(switch(2) = '1' and switch(1) = '0' and switch(3) = '0' and switch(4) = '0'
				and switch(5) = '0' and switch(6) = '0' and switch(7) = '0' and switch(8) = '0') then
				display_output <= "000000000000000000000000" & reg1_output;
			elsif(switch(3) = '1' and switch(1) = '0' and switch(2) = '0' and switch(4) = '0'
				and switch(5) = '0' and switch(6) = '0' and switch(7) = '0' and switch(8) = '0') then
				display_output <= "000000000000000000000000" & reg2_output;
			elsif(switch(4) = '1' and switch(1) = '0' and switch(2) = '0' and switch(3) = '0'
				and switch(5) = '0' and switch(6) = '0' and switch(7) = '0' and switch(8) = '0') then
				display_output <= "000000000000000000000000" & reg3_output;
			elsif(switch(5) = '1' and switch(1) = '0' and switch(2) = '0' and switch(3) = '0'
				and switch(4) = '0' and switch(6) = '0' and switch(7) = '0' and switch(8) = '0') then
				display_output <= "000000000000000000000000" & reg4_output;
			elsif(switch(6) = '1' and switch(1) = '0' and switch(2) = '0' and switch(3) = '0'
				and switch(4) = '0' and switch(5) = '0' and switch(7) = '0' and switch(8) = '0') then
				display_output <= "000000000000000000000000" & reg5_output;
			elsif(switch(7) = '1' and switch(1) = '0' and switch(2) = '0' and switch(3) = '0'
				and switch(4) = '0' and switch(5) = '0' and switch(6) = '0' and switch(8) = '0') then
				display_output <= "000000000000000000000000" & reg6_output;
			elsif(switch(8) = '1' and switch(1) = '0' and switch(2) = '0' and switch(3) = '0'
				and switch(4) = '0' and switch(5) = '0' and switch(6) = '0' and switch(7) = '0') then
				display_output <= "000000000000000000000000" & reg7_output;
			end if;
		else
			display_output <= (others => '0'); 
		end if;
	end process output_process;
	
	process(clk,reset) 
	begin
		if(rising_edge(clk)) then
			anode_counter <= anode_counter + '1';
		--else 
			--anode_counter <= (others => '0');
		end if;
	end process;
	counter <= anode_counter(18 downto 16);
	
	--Cathode Segment
	with segment_digit SELECT
		ca_output <= 
				"0000001" when "0000", --0
				"1001111" when "0001", --1
				"0010010" when "0010", --2
				"0000110" when "0011", --3
				"1001100" when "0100", --4
				"0100100" when "0101", --5
				"0100000" when "0110", --6
				"0001111" when "0111", --7
				"0000000" when "1000", --8
				"0000100" when "1001", --9
				"0001000" when "1010", --A
				"1100000" when "1011", --B
				"0110001" when "1100", --C
				"1000010" when "1101", --D
				"0110000" when "1110", --E
				"0111000" when others; --F
	
	--Anode 
	with counter select
		an_output <= 
			 "11111110" when "000",
			 "11111101" when "001",
			 "11111011" when "010",
			 "11110111" when "011",
			 "11101111" when "100",
			 "11011111" when "101",
			 "10111111" when "110",
			 "01111111" when others;

	--Break up output into individual cathodes
	with counter select
		segment_digit <=  
			display_output(3 downto 0) when "000",
			display_output(7 downto 4) when "001",
			display_output(11 downto 8) when "010",
			display_output(15 downto 12) when "011",
			display_output(19 downto 16) when "100",
			display_output(23 downto 20) when "101",
			display_output(27 downto 24) when "110",
			display_output(31 downto 28) when others;
	
end PROCESSOR_ARCHITECTURE;