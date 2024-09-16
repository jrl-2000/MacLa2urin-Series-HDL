library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
----------------ENTITY------------------------
entity top is
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        go      : in std_logic;
        XBUS    : in std_logic_vector(17 downto 0);
        ready   : out std_logic;
        RBUS    : out std_logic_vector(17 downto 0)
    );
end top;
------------ARCHITECTURE----------------------
architecture Behavioral of top is
    
    component controller is
        port (
            clk:  IN std_logic;
            rst:  IN std_logic;
            go:  IN std_logic;
			ldX: OUT std_logic;
            in1T: OUT std_logic;
            ldT: OUT std_logic;
			in1R: OUT std_logic;
            ldR: OUT std_logic;

            ready: OUT std_logic
        );
    end component controller;

    component datapath is
        port (
            clk     : IN std_logic;
            rst:  IN std_logic;
			ldX: IN std_logic;
            in1T: IN std_logic;
            ldT: IN std_logic;
			in1R: IN std_logic;
            ldR: IN std_logic;
            XBUS    : IN std_logic_vector(17 downto 0);
            RBUS : OUT std_logic_vector(17 downto 0)
        );
    end component datapath;

    signal ldX, in1T, ldT, in1R, ldR: std_logic;
begin

    DP : datapath port map (
        clk => clk,
        rst => rst,
		ldX => ldX,
        in1T => in1T,
        ldT => ldT,
        in1R => in1R,
        ldR => ldR,
        XBUS => XBUS,
        RBUS => RBUS
    );

    CU : controller port map (
        clk => clk,
        rst => rst,
        go => go,
		ldX => ldX,
        in1T => in1T,
        ldT => ldT,
        in1R => in1R,
        ldR => ldR,
        ready => ready
    );
    
end Behavioral;