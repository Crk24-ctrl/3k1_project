library IEEE;
use IEEE.std_logic_1164.all;

entity control_3k1 is
  port(
    reset        : in  std_logic; -- async
    clk          : in  std_logic;

    -- status in
    term_is_one  : in  std_logic;
    term_is_even : in  std_logic;
    length_ge_9  : in  std_logic;
    done_status  : in  std_logic;

    -- control out
    reset_number : out std_logic;
    inc_number   : out std_logic;

    load_term    : out std_logic;
    shift_term   : out std_logic;
    multadd_term : out std_logic;

    reset_length : out std_logic;
    inc_length   : out std_logic;

    load_done    : out std_logic
  );
end control_3k1;

architecture rtl of control_3k1 is
  type state_t is (
    S_RESET,
    S_LOAD_NEW,      -- TERM<=NUMBER, LENGTH<=1
    S_TEST,          -- decide next action
    S_EVEN_SHIFT,    -- TERM<=TERM/2
    S_ODD_MULTADD,   -- TERM<=3*TERM+1
    S_INC_LENGTH,    -- LENGTH++
    S_CHECK,         -- if term==1 and length>=9 => done else increment number
    S_INC_NUMBER,
    S_DONE
  );
  signal state, next_state : state_t;
begin

  process(clk, reset)
  begin
    if reset = '1' then
      state <= S_RESET;
    elsif rising_edge(clk) then
      state <= next_state;
    end if;
  end process;

  process(state, term_is_one, term_is_even, length_ge_9, done_status)
  begin
    if done_status = '1' then
      next_state <= S_DONE;
    else
      next_state <= state;
      case state is
        when S_RESET      => next_state <= S_LOAD_NEW;
        when S_LOAD_NEW   => next_state <= S_TEST;

        when S_TEST =>
          if term_is_one = '1' then
            next_state <= S_CHECK;
          else
            if term_is_even = '1' then
              next_state <= S_EVEN_SHIFT;
            else
              next_state <= S_ODD_MULTADD;
            end if;
          end if;

        when S_EVEN_SHIFT => next_state <= S_INC_LENGTH;
        when S_ODD_MULTADD=> next_state <= S_INC_LENGTH;
        when S_INC_LENGTH => next_state <= S_TEST;

        when S_CHECK =>
          if length_ge_9 = '1' then
            next_state <= S_DONE;
          else
            next_state <= S_INC_NUMBER;
          end if;

        when S_INC_NUMBER => next_state <= S_LOAD_NEW;
        when S_DONE       => next_state <= S_DONE;
      end case;
    end if;
  end process;

  process(state)
  begin
    -- defaults
    reset_number <= '0';
    inc_number   <= '0';
    load_term    <= '0';
    shift_term   <= '0';
    multadd_term <= '0';
    reset_length <= '0';
    inc_length   <= '0';
    load_done    <= '0';

    case state is
      when S_RESET =>
        reset_number <= '1';
        reset_length <= '1';

      when S_LOAD_NEW =>
        load_term    <= '1';
        reset_length <= '1';

      when S_EVEN_SHIFT =>
        shift_term <= '1';

      when S_ODD_MULTADD =>
        multadd_term <= '1';

      when S_INC_LENGTH =>
        inc_length <= '1';

      when S_INC_NUMBER =>
        inc_number <= '1';

      when S_DONE =>
        load_done <= '1';

      when others =>
        null;
    end case;
  end process;

end rtl;
