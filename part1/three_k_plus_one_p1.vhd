library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity three_k_plus_one is
  port(
    reset      : in  std_logic; -- asynch
    clk        : in  std_logic;
    number_out : out unsigned(6 downto 0);
    term_out   : out unsigned(6 downto 0);
    done_out   : out std_logic
  );
end three_k_plus_one;

architecture one_process of three_k_plus_one is
  signal number_r : unsigned(6 downto 0);
  signal term_r   : unsigned(6 downto 0);
  signal length_r : unsigned(3 downto 0);
  signal done_r   : std_logic;
begin

  number_out <= number_r;
  term_out   <= term_r;
  done_out   <= done_r;

  process(clk, reset)
  begin
    if reset = '1' then
      number_r <= to_unsigned(1, 7);
      term_r   <= to_unsigned(1, 7);
      length_r <= to_unsigned(1, 4);
      done_r   <= '0';

    elsif rising_edge(clk) then
      if done_r = '1' then
        null; -- freeze

      else
        -- If term reached 1: either done (if length>=9) or move to next number
        if term_r = to_unsigned(1, 7) then
          if length_r >= to_unsigned(9, 4) then
            done_r <= '1';
          else
            number_r <= number_r + 1;
            term_r   <= number_r + 1;       -- load new term = new number
            length_r <= to_unsigned(1, 4);  -- reset length
          end if;

        else
          -- Generate next term (one per clock)
          if term_r(0) = '0' then
            -- even: divide by 2 (shift right)
            term_r <= shift_right(term_r, 1);
          else
            -- odd: 3*term + 1 (resize to 7 bits)
            term_r <= resize((term_r * 3) + 1, 7);
          end if;

          -- increment length each time we generate a new term
          length_r <= length_r + 1;
        end if;
      end if;
    end if;
  end process;

end one_process;
