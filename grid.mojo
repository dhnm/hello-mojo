import random

from memory import UnsafePointer, memcpy, memset_zero

struct Grid[rows: Int, cols: Int](StringableRaising, Copyable):
    alias num_cells = rows * cols
    var data: UnsafePointer[Int8]

    def __init__(out self):
        self.data = UnsafePointer[Int8]().alloc(self.num_cells)
        memset_zero(self.data, self.num_cells)

    fn __copyinit__(out self, existing: Self):
        self.data = UnsafePointer[Int8]().alloc(self.num_cells)
        memcpy(dest=self.data, src=existing.data, count=self.num_cells)

    fn __del__(owned self):
        for i in range(self.num_cells):
            (self.data + 1).destroy_pointee()
        self.data.free()

    def __getitem__(self, row: Int, col: Int) -> Int8:
        return (self.data + row * cols + col)[]

    def __setitem__(mut self, row: Int, col: Int, value: Int8) -> None:
        (self.data + row * cols + col)[] = value

    def __str__(self) -> String:
        """
        Converts a grid of integers into a string representation.
        """
        str = String()

        # Iterate through each row
        for row in range(rows):
            # Iterate through each column
            for col in range(cols):
                if self[row, col] == 1:
                    str += "🟩" # If cell is populated, append an asterisk
                else:
                    str += "⬜" # If cell is not populated, append a space
            if row != rows - 1:
                str += "\n" # Append newline after each row except the last one
        return str

    @staticmethod
    def random() -> Self:
        """
        Generates a random grid of integers.
        """

        # Seed the random number generator using the current time
        random.seed()

        grid = Self()
        random.randint(grid.data, grid.num_cells, 0, 1)

        return grid


    def evolve(self) -> Self:
        next_generation = Self()

        for row_idx in range(rows):
            # Calculate neighboring row indices, handling wrap-around
            row_above = (row_idx - 1) % rows
            row_below = (row_idx + 1) % rows

            for col_idx in range(cols):
                # Calculate neighboring column indices, handling wrap-around
                col_left = (col_idx - 1) % cols
                col_right = (col_idx + 1) % cols

                # Determine number of populated cells around
                num_neighbors = (
                    self[row_above, col_left]
                    + self[row_above, col_idx]
                    + self[row_above, col_right]
                    + self[row_idx, col_left]
                    + self[row_idx, col_right]
                    + self[row_below, col_left]
                    + self[row_below, col_idx]
                    + self[row_below, col_right]
                )

                # Determine the state of the current cell for the next generation
                if num_neighbors | self[row_idx, col_idx] == 3:
                    next_generation[row_idx, col_idx] = 1

        return next_generation
