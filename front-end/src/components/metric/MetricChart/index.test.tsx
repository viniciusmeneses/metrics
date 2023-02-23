import ReactApexChart from "react-apexcharts";

import { waitFor } from "@testing-library/react";

import { render } from "../../../testUtils";

import { MetricChart } from ".";

const mockProps = {
  name: "Metric",
  series: [
    ["2020-01-10T20:00:00+01:00", 2000],
    ["2020-01-11T15:00:00+01:00", 1000],
    ["2020-01-12T06:00:00+01:00", 250],
    ["2020-01-13T10:00:00+01:00", 250],
    ["2020-01-14T12:00:00+01:00", 50],
    ["2020-01-15T15:00:00+01:00", 5],
  ] as [string, number][],
};

jest.mock("react-apexcharts", () => ({
  __esModule: true,
  default: jest.fn().mockReturnValue(null),
}));

describe("MetricChart", () => {
  it("renders chart correctly", async () => {
    render(<MetricChart {...mockProps} />);
    await waitFor(() =>
      expect(ReactApexChart).toHaveBeenCalledWith(
        expect.objectContaining({
          series: [
            {
              name: "Metric",
              data: [
                [1578682800000, 2000],
                [1578751200000, 1000],
                [1578805200000, 250],
                [1578906000000, 250],
                [1578999600000, 50],
                [1579096800000, 5],
              ],
            },
          ],
        }),
        {},
      ),
    );
  });
});
