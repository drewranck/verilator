// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2022 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0

module t
  (/*AUTOARG*/
   // Inputs
   clk
   );

  input clk;

  int   cyc = 0;


  int normal_queue [$];
  int array_of_queues [3][$];
  int aa_of_queues [int][$];

  function void test_normal_queue();

    $display("%t %m: Testing single queue (int normal_queue [$])", $realtime);

    assert(normal_queue.size() == 0) else begin
      $error("%t %m: normal_queue.size() should be 0 but is %0d",
               $realtime, normal_queue.size());
    end

    repeat(4)
      normal_queue.push_back($urandom);

    assert(normal_queue.size() == 4) else begin
      $error("%t %m: normal_queue.size() should be 4 but is %0d",
               $realtime, normal_queue.size());
    end

    repeat(4)
      void'(normal_queue.pop_front());

    assert(normal_queue.size() == 0) else begin
      $error("%t %m: normal_queue.size() should be 0 but is %0d",
               $realtime, normal_queue.size());
    end

  endfunction : test_normal_queue



  function void test_array_of_queues();

    $display("%t %m: Testing array of queues (int array_of_queues [3][$])", $realtime);

    array_of_queues[0] = {};
    array_of_queues[1] = {};
    array_of_queues[2] = {};

    for (int i = 0; i < 3; i++) begin
      assert(array_of_queues[i].size() == 0) else begin
        $error("%t %m: array_of_queues[%0d].size() should be 0 but is %0d",
               $realtime, i, array_of_queues[i].size());
      end
    end

    for (int i = 0; i < 3; i++) begin
      for (int j = 0; j < 4; j++) begin : push_4_items
        array_of_queues[i].push_back($urandom);
        $display("%t %m: array_of_queues, pushed item to queue %0d: [0]=%p [1]=%p [2]=%p",
                 $realtime, i, array_of_queues[0], array_of_queues[1], array_of_queues[2]);
        assert(array_of_queues[i].size() == j + 1) else begin
          $error("%t %m: array_of_queues[%0d].size() should be %0d but is %0d, queue=%p",
                 $realtime, i, j + 1, array_of_queues[i].size(), array_of_queues[i]);
        end
      end
    end

    for (int i = 0; i < 3; i++) begin : pop_4_items_from_each
      repeat(4)
        void'(array_of_queues[i].pop_front());
      assert(array_of_queues[i].size() == 0) else begin
        $error("%t %m: array_of_queues[%0d].size() should be 0 but is %0d",
               $realtime, i, array_of_queues[i].size());
      end
    end

  endfunction : test_array_of_queues



  function void test_aa_of_queues();

    $display("%t %m: Testing associative-array of queues (int aa_of_queues [int][$])", $realtime);

    aa_of_queues[0] = {};
    aa_of_queues[1] = {};
    aa_of_queues[2] = {};

    for (int i = 0; i < 3; i++) begin
      assert(aa_of_queues[i].size() == 0) else begin
        $error("%t %m: aa_of_queues[%0d].size() should be 0 but is %0d",
               $realtime, i, aa_of_queues[i].size());
      end
    end

    for (int i = 0; i < 3; i++) begin
      for (int j = 0; j < 4; j++) begin : push_4_items
        aa_of_queues[i].push_back($urandom);
        $display("%t %m: aa_of_queues, pushed item to queue %0d: [0]=%p [1]=%p [2]=%p",
                 $realtime, i, aa_of_queues[0], aa_of_queues[1], aa_of_queues[2]);
        assert(aa_of_queues[i].size() == j + 1) else begin
          $error("%t %m: aa_of_queues[%0d].size() should be %0d but is %0d, queue=%p",
                 $realtime, i, j + 1, aa_of_queues[i].size(), aa_of_queues[i]);
        end
      end
    end

    for (int i = 0; i < 3; i++) begin
      repeat(4)
        void'(aa_of_queues[i].pop_front());
      assert(aa_of_queues[i].size() == 0) else begin
        $error("%t %m: aa_of_queues[%0d].size() should be 0 but is %0d",
               $realtime, i, aa_of_queues[i].size());
      end
    end

  endfunction : test_aa_of_queues


  initial begin

    cyc++;
    test_normal_queue();

    cyc++;
    test_aa_of_queues();

    cyc++;
    test_array_of_queues();

    cyc++;
    $display("%t %m: Test finshed", $realtime);
    $finish();

  end


endmodule : t
