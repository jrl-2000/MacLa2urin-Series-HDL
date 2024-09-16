library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
----------------ENTITY------------------------
entity testbench is
end testbench;
------------ARCHITECTURE----------------------
architecture simulation of testbench is
    signal clk, rst, go, ready : std_logic := '0';
    signal XBUS : std_logic_vector(17 downto 0) := "000000000000000000";
    signal RBUS : std_logic_vector(17 downto 0);

    -- UUT
    component top is
        port (
            clk     : in std_logic;
            rst     : in std_logic;
            go      : in std_logic;
            XBUS    : in std_logic_vector;
            ready   : out std_logic;
            RBUS    : out std_logic_vector
        );
    end component top;

begin

    process begin
        wait for 5 ns;
        clk <= not clk;
    end process;

    process begin
        wait for 5 ns;
        rst <= '0';
        wait for 5 ns;
        rst <= '1';
        wait for 5 ns;
        rst <= '0';
        wait for 10 ns;
        go <= '1';
		XBUS <= "000000000000000000"; -- 0
        wait for 20 ns;
        go <= '0';

        wait for 340 ns;
        XBUS <= "001000000000000000"; -- 0.5
		go <= '1';
        wait for 20 ns;
		go <= '0';
		wait for 340 ns;
		
        XBUS <= "000100000000000000"; -- 0.25
        go <= '1';
        wait for 20 ns;
		go <= '0';
		wait for 600 ns;
    end process;

    UUT : top port map(
        clk => clk,
        rst => rst,
        go => go,
        XBUS => XBUS,
        ready => ready,
        RBUS => RBUS
    );

end simulation; 