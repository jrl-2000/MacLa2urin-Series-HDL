library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Jonathan Lopez
-- ECE 5723 Spring 2024 WPI
-- Midterm Exam Question # 1: VHDL Modeling
-- Simualtor: Siemens (Mentor Graphics) ModelSim Intel FPGA Starter Editon 2020.1
-- Description: Datapath Module for Approximator Circuit of (1/(1-x^2))

entity Datapath is
    port (
        -- Inputs
        clk     : in std_logic;
        rst     : in std_logic;
        XBus    : in std_logic_vector(17 downto 0);
        in1T    : in std_logic;
        in1R    : in std_logic;
        Idx     : in std_logic;
        IdT     : in std_logic;
        IdR     : in std_logic;

        -- Output
        RBus : out std_logic_vector(17 downto 0)
    );
end Datapath;

architecture Behavorial of Datapath is
    -- Signals
    -- 32-Bits
    signal Mult_Out_32_Reg : std_logic_vector(31 downto 0):= (others => '0');

    -- 18-Bits
    signal R_Reg : std_logic_vector(17 downto 0):= (others => '0');

    signal Adder_Out : std_logic_vector(17 downto 0):= (others => '0'); 

   -- 16-Bits
    signal X2_Reg : std_logic_vector(31 downto 0):= (others => '0');
    signal T_Reg : std_logic_vector(15 downto 0):= (others => '0');   

begin

    -- Multiplier
    process (X2_Reg, T_Reg) begin
        Mult_Out_32_Reg <= X2_Reg(31 downto 16) * T_Reg;
    end process;

    -- X^2 Register
    process (clk, Idx) begin
        if rising_edge(clk) then
            if (XBus >= X"00000" and Idx = '1') then
                X2_Reg <= XBus(15 downto 0) * XBus(15 downto 0);
                --X2_Reg <= X@_Reg(31 downto 16); 
            end if;
        end if;
    end process;

    -- T Register
    process (clk, IdT, in1T) begin
        if rising_edge(clk) then
            if (in1T = '1') then
                T_Reg <= "1111111111111111";
            elsif (IdT = '1') then
                T_Reg <= Mult_Out_32_Reg(15 downto 0);
            end if;
        end if;
    end process;

    -- R Register
    process (clk, IdR, in1R) begin
        if rising_edge(clk) then
            if (in1R = '1') then
                R_Reg <= "010000000000000000";
            elsif (IdR = '1') then
                R_Reg <= Adder_Out;
            end if;
        end if;
    end process;


    -- Adder
    process(R_Reg, T_Reg) begin
        Adder_Out <= "00" & T_Reg + R_Reg;
    end process;

    -- RBus
    process(R_Reg) begin
        RBus <= R_Reg;
    end process;

end Behavorial; 