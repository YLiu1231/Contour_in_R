# Contour_in_R
## Background
My friend's major is environmental engineering, one of her projects aims to analyze the distribution of concentration of copper in Jinshan Lake, Zhenjiang City, Jiangsu Province, China. Her data set is like `concentration_and_coordinates.xlsx`. The shape of Jinshan Lake is shown in `emptylake.png`. 

![emptylake](https://github.com/YLiu1231/Contour_in_R/blob/master/emptylake.png)

There are 35 observation points in total, the distribution of them is shown in `example.png`.

![example](https://github.com/YLiu1231/Contour_in_R/blob/master/example.png)

She wants to create a Contour plot like `lake.png`.

![lake](https://github.com/YLiu1231/Contour_in_R/blob/master/lake.png)

## Contour plot in R

As usual, we draw contour plot by `ggplot()+scale_fill_gradientn()+stat_contour()`, they draw base map, fill in colors, draw the target contour plot respectively. But the input data should have all coordinates and corresponding concentration. However, here we just have 35 observations, we should do more work to calculate concentration value for each coordinate.

## Several attempts for interpolation
### linear fitting
At the very first, I try to use linear fitting model, which is easy but time-consuming. I divide the plane into 70 nonoverlapping triangles like `fulllake.png`.

![fulllake](https://github.com/YLiu1231/Contour_in_R/blob/master/fulllake.png)

This method is naive but easy to realize. The result is hard to distinguish and the patterns are angular(I will not show this ugly result).

### polynomial fitting
then I try to use some mathematical method, construct a linear system of equations. 
![system of equation](https://github.com/YLiu1231/Contour_in_R/blob/master/system%20of%20equations.png)

If we can solve this system of equations, we can use the parameter vector to calculate concentration of each coordinate. But the most imortant problem is the boundedness of the polynomial at the edge of this lake. Unfortunately, the assumption is not satisfied.
the last plot is like `polynomial.pdf`.

### overlap fitting 
calculate the value of one single point by the distance between this point and the target. Suppose now we use the 1st observation. The coordinate of it is (x0,y0), the concentration is z0. So for any point in the plane. We use function
![function](https://github.com/YLiu1231/Contour_in_R/blob/master/concentration%20by%20distance.png)

then we have the final plot 

![Rplotlake](https://github.com/YLiu1231/Contour_in_R/blob/master/Rplotlake.png)

