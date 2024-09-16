library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Jonathan Lopez
-- ECE 5723 Spring 2024 WPI
-- Midterm Exam Question # 1: VHDL Modeling
-- Simualtor: Siemens (Mentor Graphics) ModelSim Intel FPGA Starter Editon 2020.1
-- Description: Controller Module for Approximator Circuit of (1/(1-x^2))

entity Controller is
    port (
        -- Inputs
        clk     : in std_logic;
        rst     : in std_logic;
        go      : in std_logic;
        

        -- Outputs
        in1T    : out std_logic;
        in1R    : out std_logic;
        Idx     : out std_logic;
        IdT     : out std_logic;
        IdR     : out std_logic;
        ready   : out std_logic
    );
end Controller;
architecture Behavorial of Controller is
    signal in0C :std_logic;
    signal incC :std_logic;
    signal coC  : std_logic;
    signal counter : std_logic_vector(3 downto 0);
    -- State Machine Enum
    type StateT is (IDLE, LOAD, TERM, RES);
    signal state : StateT;
begin
    process(clk, rst)
    begin
        if (rst = '1') then
            state <= IDLE;
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    in0C <= '0';
                    incC <= '0';
                    in1T <= '0';
                    in1R <= '0';
                    Idx <= '0';
                    IdT <= '0';
                    IdR <= '0';
                    ready <= '1';

                    if go = '1' then
                        ready <= '0';
                        state <= LOAD;
                    end if;
                when LOAD =>
                    -- Set High
                    in1T <= '1';
                    in1R <= '1';
                    in0C <= '1';
                    Idx <= '1';

                    if go = '0' then
                        state <= TERM;
                    end if;
                when TERM =>
                    -- Set High
                    IdT <= '1';

                    -- Set Low from LOAD
                    in1T <= '0';
                    in1R <= '0';
                    in0C <= '0';
                    Idx <= '0';

                    -- From RES
                    IdR <= '0';
                    incC <= '0';

                    state <= RES;
                when RES =>
                    -- Set High
                    IdR <= '1';
                    incC <= '1';

                    -- Set Low
                    IdT <= '0';

                    if coC = '1' then
                        state <= IDLE;
                    else
                        state <= TERM;
                    end if;                    
            end case; 
        end if;
    end process;
-- Counter
    process(clk, rst, in0C, incC, counter) begin
        if rising_edge(clk) then
            if (rst = '1') then
                --counter <= (others => '0');
                coC <= '0';
            elsif (in0C = '1') then
                counter <= (others => '0');
                coC <= '0';
            elsif (incC = '1' and counter /= "1111") then
                counter <= counter + '1';
                coC <= '0';
            elsif (counter = "1111") then
                coC <= '1';
            end if;
        end if;
    end process;
end Behavorial; 