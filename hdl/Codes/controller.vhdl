LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
----------------ENTITY------------------------
ENTITY controller IS
	PORT(
        clk:  IN STD_LOGIC;
        rst:  IN STD_LOGIC;
        go:  IN STD_LOGIC;
		
		ldX: OUT std_logic;
        in1T: OUT std_logic; 
		ldT: OUT std_logic; 
		
        in1R: OUT std_logic; 
		ldR: OUT std_logic; 
        
        ready: OUT std_logic);
END ENTITY;
------------ARCHITECTURE----------------------
ARCHITECTURE Behavioral OF controller IS

	TYPE state IS (idle, load, term, res);
	SIGNAL p_state, n_state : state; 
	SIGNAL in0C, incC, coC: STD_LOGIC;
    SIGNAL cnt : STD_LOGIC_VECTOR (3 DOWNTO 0);

BEGIN 
	
	combinational_part:PROCESS(p_state, go, coC)
	BEGIN
		ready <= '0'; ldX <= '0';
		in1T <= '0'; ldT <= '0';
		in1R <= '0'; ldR <= '0';
		in0C <= '0'; incC <= '0';
		CASE p_state IS
			WHEN idle =>
				IF go = '1' THEN n_state <= load; 
				ELSE n_state <= idle; END IF;
				ready <= '1'; ldX <= '0';
				in1T <= '0'; ldT <= '0';
				in1R <= '0'; ldR <= '0';
				in0C <= '0'; incC <= '0';
				
			WHEN load =>
				IF go = '0' THEN n_state <= term; 
				ELSE n_state <= load; END IF;
				ready <= '0'; ldX <= '1';
				in1T <= '1'; ldT <= '0';
				in1R <= '1'; ldR <= '0';
				in0C <= '1'; incC <= '0';
				
			WHEN term =>
				n_state <= res; 
				ready <= '0'; ldX <= '0';
				in1T <= '0'; ldT <= '1';
				in1R <= '0'; ldR <= '0';
				in0C <= '0'; incC <= '0';
				
			WHEN res =>
				IF coC = '1' THEN n_state <= idle; 
				ELSE n_state <= term; END IF;
				ready <= '0'; ldX <= '0';
				in1T <= '0'; ldT <= '0';
				in1R <= '0'; ldR <= '1';
				in0C <= '0'; incC <= '1';
		END CASE;
	END PROCESS;
						
	sequential_part: PROCESS (clk, rst)
	BEGIN
	IF (rst = '1') THEN
		p_state <= idle;
	ELSIF (clk = '1' AND clk'EVENT) THEN
		 p_state <= n_state;
	END IF;
	END PROCESS;

	PROCESS (clk, rst)
	BEGIN
		IF (rst='1' OR in0C='1') THEN
			cnt<= (OTHERS=>'0');
		ELSIF (clk = '1' AND clk'EVENT) THEN
			IF (incC = '1') THEN
				cnt <= cnt + 1;
			END IF;
		END IF;
	END PROCESS;
	
	coC <= cnt(0) AND cnt(1) AND cnt(2) AND cnt(3); 
									
END ARCHITECTURE;