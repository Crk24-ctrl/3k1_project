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

architecture rtl of three_k_plus_one is
  -- CU->DP control
  signal reset_number, inc_number : std_logic;
  signal load_term, shift_term, multadd_term : std_logic;
  signal reset_length, inc_length : std_logic;
  signal load_done : std_logic;

  -- DP->CU status
  signal term_is_one, term_is_even, length_ge_9 : std_logic;
  signal done_status : std_logic;

  signal number_i : unsigned(6 downto 0);
  signal term_i   : unsigned(6 downto 0);
begin

  U_DP: entity work.datapath_3k1
    port map(
      reset        => reset,
      clk          => clk,

      reset_number => reset_number,
      inc_number   => inc_number,

      load_term    => load_term,
      shift_term   => shift_term,
      multadd_term => multadd_term,

      reset_length => reset_length,
      inc_length   => inc_length,

      load_done    => load_done,

      term_is_one  => term_is_one,
      term_is_even => term_is_even,
      length_ge_9  => length_ge_9,
      done_status  => done_status,

      number_q     => number_i,
      term_q       => term_i
    );

  U_CU: entity work.control_3k1
    port map(
      reset        => reset,
      clk          => clk,

      term_is_one  => term_is_one,
      term_is_even => term_is_even,
      length_ge_9  => length_ge_9,
      done_status  => done_status,

      reset_number => reset_number,
      inc_number   => inc_number,

      load_term    => load_term,
      shift_term   => shift_term,
      multadd_term => multadd_term,

      reset_length => reset_length,
      inc_length   => inc_length,

      load_done    => load_done
    );

  number_out <= number_i;
  term_out   <= term_i;
  done_out   <= done_status;

end rtl;
