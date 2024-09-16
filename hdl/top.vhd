library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Jonathan Lopez
-- ECE 5723 Spring 2024 WPI
-- Midterm Exam Question # 1: VHDL Modeling
-- Simualtor: Siemens (Mentor Graphics) ModelSim Intel FPGA Starter Editon 2020.1
-- Description: Top Module for Approximator Circuit of (1/(1-x^2))

entity top is
    port (
        -- Inputs
        clk     : in std_logic;
        rst     : in std_logic;
        go      : in std_logic;
        XBus    : in std_logic_vector(17 downto 0);

        -- Outputs
        ready   : out std_logic;
        RBus    : out std_logic_vector(17 downto 0)
    );
end top;


architecture Behavorial of top is
    --Component Instantiations
    component Controller is
        port (
            clk     : in std_logic;
            rst     : in std_logic;
            go      : in std_logic;

            in1T    : out std_logic;
            in1R    : out std_logic;
            Idx     : out std_logic;
            IdT     : out std_logic;
            IdR     : out std_logic;
            ready   : out std_logic
        );
    end component Controller;

    component Datapath is
        port (
            clk     : in std_logic;
            rst     : in std_logic;
            in1T    : in std_logic;
            in1R    : in std_logic;
            Idx     : in std_logic;
            IdT     : in std_logic;
            IdR     : in std_logic;
            XBus    : in std_logic_vector(17 downto 0);

            RBus    : out std_logic_vector(17 downto 0)
        );
    end component Datapath;
    
    --Connecting Module Signals
    signal in1T :std_logic;
    signal in1R :std_logic;
    signal Idx  : std_logic;
    signal IdT :std_logic;
    signal IdR :std_logic;

begin
    CNTRLR_0 : Controller port map (
        clk => clk,
        rst => rst,
        go => go,
        in1T => in1T,
        in1R => in1R,
        Idx => Idx,
        IdT => IdT,
        IdR => IdR,
        ready => ready
    );

    DP_0 : Datapath port map (
        clk => clk,
        rst => rst,
        in1T => in1T,
        in1R => in1R,
        Idx => Idx,
        IdT => IdT,
        IdR => IdR,
        XBus => XBus,
        RBus => RBus
    );
    
end Behavorial;
