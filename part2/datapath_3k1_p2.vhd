library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity datapath_3k1 is
  port(
    reset        : in  std_logic; 
    clk          : in  std_logic;

    reset_number : in  std_logic;
    inc_number   : in  std_logic;

    load_term    : in  std_logic;  
    shift_term   : in  std_logic; 
    multadd_term : in  std_logic; 

    reset_length : in  std_logic; 
    inc_length   : in  std_logic; 

    load_done    : in  std_logic;  
    
    term_is_one  : out std_logic;
    term_is_even : out std_logic;
    length_ge_9  : out std_logic;
    done_status  : out std_logic;

    number_q     : out unsigned(6 downto 0);
    term_q       : out unsigned(6 downto 0)
  );
end datapath_3k1;

architecture rtl of datapath_3k1 is
  signal number_r : unsigned(6 downto 0);
  signal term_r   : unsigned(6 downto 0);
  signal length_r : unsigned(3 downto 0);
  signal done_r   : std_logic;
begin

  process(clk, reset)
  begin
    if reset = '1' then
      number_r <= to_unsigned(1, 7);
    elsif rising_edge(clk) then
      if reset_number = '1' then
        number_r <= to_unsigned(1, 7);
      elsif inc_number = '1' and done_r = '0' then
        number_r <= number_r + 1;
      end if;
    end if;
  end process;


  process(clk, reset)
  begin
    if reset = '1' then
      term_r <= to_unsigned(1, 7);
    elsif rising_edge(clk) then
      if done_r = '0' then
        if load_term = '1' then
          term_r <= number_r;
        elsif shift_term = '1' then
          term_r <= shift_right(term_r, 1);
        elsif multadd_term = '1' then
          term_r <= resize((term_r * 3) + 1, 7);
        end if;
      end if;
    end if;
  end process;

  process(clk, reset)
  begin
    if reset = '1' then
      length_r <= to_unsigned(1, 4);
    elsif rising_edge(clk) then
      if done_r = '0' then
        if reset_length = '1' then
          length_r <= to_unsigned(1, 4);
        elsif inc_length = '1' then
          length_r <= length_r + 1;
        end if;
      end if;
    end if;
  end process;


  process(clk, reset)
  begin
    if reset = '1' then
      done_r <= '0';
    elsif rising_edge(clk) then
      if load_done = '1' then
        done_r <= '1';
      end if;
    end if;
  end process;


  term_is_one  <= '1' when term_r = to_unsigned(1, 7) else '0';
  term_is_even <= '1' when term_r(0) = '0' else '0';
  length_ge_9  <= '1' when length_r >= to_unsigned(9, 4) else '0';
  done_status  <= done_r;

  number_q <= number_r;
  term_q   <= term_r;

end rtl;
