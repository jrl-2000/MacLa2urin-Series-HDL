library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
----------------ENTITY------------------------
entity datapath is
    port (
        clk: IN std_logic;
        rst: IN std_logic;

        ldX: IN std_logic;
		in1T: IN std_logic;
		ldT: IN std_logic; 
        in1R: IN std_logic; 
		ldR: IN std_logic; 
        
        XBUS: IN std_logic_vector(17 downto 0);
        RBUS: OUT std_logic_vector(17 downto 0)
    );
end datapath;
------------ARCHITECTURE----------------------
architecture Behavioral of datapath is
    signal x2reg: std_logic_vector (15 downto 0):= (others => '0');
	signal x2true: std_logic_vector (31 downto 0):= (others => '0'); 
	signal mult: std_logic_vector (33 downto 0):= (others => '0'); 
	signal treg, adder, rreg: std_logic_vector (17 downto 0):= (others => '0');
	
begin

    process(clk, rst)
    begin
      if (rst='1') then
		x2reg <= (others=>'0');
		treg <= (others=>'0');
		mult <= (others=>'0');
		adder <= (others=>'0');
		rreg <= (others=>'0');
      elsif(clk='1' and clk'event) then
	  
        x2true <= XBUS(15 downto 0) * XBUS(15 downto 0);
		
		if(ldX='1') then
			x2reg <= x2true(31 downto 16);
		end if;
		
		if(in1T='1') then --T_register
            treg<="010000000000000000";
        elsif (ldT='1') then
            treg<= mult(33 downto 16); --18MSB
        end if;
		
		mult <= x2reg * treg;
		
		if(in1R='1') then
            rreg<=(others=>'0');
        elsif (ldR='1') then
            rreg<=adder; 
        end if;
		
		adder <= treg + rreg;
		RBUS <= rreg; 
		
      end if;  
    end process;

end Behavioral; 