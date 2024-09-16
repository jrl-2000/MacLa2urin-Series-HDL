library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Jonathan Lopez
-- ECE 5723 Spring 2024 WPI
-- Midterm Exam Question # 1: VHDL Modeling
-- Simualtor: Siemens (Mentor Graphics) ModelSim Intel FPGA Starter Editon 2020.1
-- Description: Top Testbench Module for Approximator Circuit of (1/(1-x^2))



entity testbench is
end testbench;

architecture simulation of testbench is
    signal clk, go, ready : std_logic := '0';
    signal rst : std_logic := '0';
    signal XBus : std_logic_vector(17 downto 0);
    signal RBus : std_logic_vector(17 downto 0);

    -- UUT
    component top is
        port (
            clk     : in std_logic;
            rst     : in std_logic;
            go      : in std_logic;
            XBus    : in std_logic_vector(17 downto 0);
            ready   : out std_logic;
            RBus : out std_logic_vector(17 downto 0)
        );
    end component top;
begin
    process begin
        wait for 5 ns;
        clk <= not clk;
    end process;

process begin
        -- Hit reset!
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;

        -- Full Pulse on go
        wait for 15 ns;
        go <= '1';
        wait for 10 ns;
        go <= '0'; 

        -- Put Data on XBus
        XBus <= "000011110111000000";
        wait for 32 ns;      

        wait for 1000 ns;
        assert false report "End Sim" severity failure;
    end process;

    top_UUT : top port map(
        clk => clk,
        rst => rst,
        go => go,
        XBus => XBus,
        ready => ready,
        RBus => RBus
    );

end simulation; 
