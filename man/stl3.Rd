\name{stl3}
\alias{stl3}
\alias{stl3.default}
\alias{stl3.ts}
\title{Seasonal Decomposition of Time Series by Loess}
\description{
   Decompose a time series into seasonal, trend and irregular components using \code{loess}, acronym STL.  A new implementation of STL.  Allows for NA values, local quadratic smoothing,  post-trend smoothing, and endpoint blending.  The usage is very similar to that of R's built-in \code{stl()}.
}
\usage{
stl3(x, t = NULL, n.p, trend = 0, fc.first=0, fc.second=0,  weight = 1, s.window, s.degree = 1, 
   t.window = NULL, t.degree = 1, 
   fc.window = NULL, fc.degree = NULL, fc.name = NULL, 
   l.window = NULL, l.degree = t.degree, 
   s.jump=ceiling(s.window/10), t.jump=ceiling(t.window/10), 
   l.jump=ceiling(l.window/10), fc.jump = NULL, 
   critfreq = 0.05, s.blend = 0, t.blend = 0, 
   l.blend = t.blend, fc.blend=NULL, 
   inner = 2, outer = 1, 
   sub.labels = NULL, sub.start=1, details = FALSE,
   ...)
}
\arguments{
  	\item{x}{vector of time series values, in order of time.  If \code{x} is a time series object, then \code{t} and \code{n.p} do not need to be specified, although they still can be.}
	\item{t}{times at which the time series values were observed.  Not required.}
	\item{n.p}{periodicity of the seasonal component.  In R's \code{stl} function, this is the frequency of the time series.}
	\item{trend}{initial trend component, it can be a vector which has the same length as x, or it is vector 0.}
	\item{fc.first}{initial first fc component, it can be a vector which has the same length as x, or it is vector 0.}
	\item{fc.second}{initial second fc component, it can be a vector which has the same length as x, or it is vector 0.}
	\item{weight}{initial weights which will be used for the outer loop, default is all 1.}
	\item{s.window}{either the character string \code{"periodic"} or the span (in lags) of the loess window for seasonal extraction, which should be odd.  This has no default.}
	\item{s.degree}{degree of locally-fitted polynomial in seasonal extraction.  Should be 0, 1, or 2.}
	\item{t.window}{the span (in lags) of the loess window for trend extraction, which should be odd.  If \code{NULL}, the default, \code{nextodd(ceiling((1.5*period) / (1-(1.5/s.window))))}, is taken.}
	\item{t.degree}{degree of locally-fitted polynomial in trend extraction.  Should be 0, 1, or 2.}
	\item{l.window}{the span (in lags) of the loess window of the low-pass filter used for each subseries.  Defaults to the smallest odd integer greater than or equal to \code{n.p} which is recommended since it prevents competition between the trend and seasonal components.  If not an odd integer its given value is increased to the next odd one.}
	\item{l.degree}{degree of locally-fitted polynomial for the subseries low-pass filter.  Should be 0, 1, or 2.}
  \item{critfreq}{the critical frequency to use for automatic calculation of smoothing windows for the trend and high-pass filter.}
  \item{fc.window}{vector of lengths of windows for loess smoothings for other trend frequency components after the original STL decomposition has been obtained.  The smoothing is applied to the data with the STL seasonal component removed.  A frequency component is computed by a loess fit with the window length equal to the first element of fc.window, the component is removed, another component is computed with the window length equal to the second element of fc.window, and so forth. In most cases, the values of the argument should be decreasing, that is, the frequency bands of the fitted components should increase. The robustness weights from original STL are used as weights in the loess fitting if specified.}
  \item{fc.degree}{vector of degrees of locally-fitted polynomial in the loess smoothings for the frequency components specified in fc.window. Values of 0, 1 and 2 are allowed. If the length of fc.degree is less than that of fc.window, the former is expanded to the length of the latter using rep; thus, giving the value 1 specifies a degree of 1 for all components.}
  \item{fc.name}{vector of names of the post-trend smoothing operations specified by \code{fc.window} and \code{fc.degree} (optional).}
   \item{inner}{integer; the number of \sQuote{inner} (backfitting) iterations; usually very few (2) iterations suffice.}
   \item{outer}{integer; the number of \sQuote{outer} robustness iterations.  Default is 0, but Recommended if outliers are present.}
   \item{sub.labels}{optional vector of length n.p that contains the labels of the subseries in their natural order (such as month name, day of week, etc.), used for strip labels when plotting.  All entries must be unique.}
   \item{sub.start}{which element of sub.labels does the series begin with.  See details.}
   \item{details}{if \code{TRUE}, returns a list of the results of all the intermediate iterations.}
   \item{s.jump, t.jump, l.jump, fc.jump}{integers at least one to increase speed of the respective smoother.  Cubic interpolation happens between every \code{*.jump}th value.}
   \item{s.blend, t.blend, l.blend, fc.blend}{vectors of proportion of blending to degree 0 polynomials at the endpoints of the series.}
   \item{...}{}
}
\details{
The seasonal component is found by \emph{loess} smoothing the
seasonal sub-series (the series of all January values, \ldots); if
\code{s.window = "periodic"} smoothing is effectively replaced by
taking the mean. The seasonal values are removed, and the remainder
smoothed to find the trend. The overall level is removed from the
seasonal component and added to the trend component. This process is
iterated a few times.  The \code{remainder} component is the
residuals from the seasonal plus trend fit.

Cycle-subseries labels are useful for plotting and can be specified through the sub.labels argument.  Here is an example for how the sub.labels and sub.start parameters might be set for one situation.  Suppose we have a daily series with n.p=7 (fitting a day-of-week component).  Here, sub.labels could be set to c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat").  Now, if the series starts with a Wednesday value, then one would specify sub.labels=4, since Wednesday is the fourth element of sub.labels.  This ensures that the labels in the plots to start the plotting with Sunday cycle-subseries instead of Wednesday.
}
\value{
   returns an object of class \code{"stl3"}, containing
   \item{data}{data frame containing all of the components: \code{raw}, \code{seasonal}, \code{trend}, \code{remainder}, \code{weights}.}
   \item{pars}{list of parameters used in the procedure.}
   \item{fc.number}{number of post-trend frequency components fitted.}
   \item{fc}{data frame of the post-trend frequency components.}
   \item{time}{vector of time values corresponding to the raw values, if specified.}
   \item{n}{the number of observations.}
   \item{sub.labels}{the cycle-subseries labels.}
}
\references{
R. B. Cleveland, W. S. Cleveland, J. E.  McRae, and I. Terpenning (1990) STL:  A  Seasonal-Trend  Decomposition  Procedure Based on Loess. \emph{Journal of Official Statistics}, \bold{6}, 3--73.
}
\author{Ryan Hafen}
\note{
   This is a complete re-implementation of the STL algorithm, with the loess part in C and the rest in R.  Moving a lot of the code to R makes it easier to experiment with the method at a very minimal speed cost.  Recoding in C instead of using R's built-in loess results in better performance, especially for larger series.}
\seealso{\code{\link{plot.stl3}} for plotting the components.

\code{\link{getraw}}, \code{\link{seasonal}}, \code{\link{trend}}, \code{\link{remainder}} for accessing the components.}
\examples{
co2.stl <- stl3(co2, t=as.vector(time(co2)), n.p=12, 
   l.window=13, t.window=19, s.window=35, s.degree=1, 
   sub.labels=substr(month.name, 1, 3))

plot(co2.stl, ylab="CO2 Concentration (ppm)", xlab="Time (years)")
plot.seasonal(co2.stl)
plot.trend(co2.stl)
plot.cycle(co2.stl)
plot.rembycycle(co2.stl)

# post-trend smoothing

co2.stl_pt <- stl3(co2, t=as.vector(time(co2)), n.p=12, 
   l.window=13, t.window=19, s.window=35, s.degree=1, 
   sub.labels=substr(month.name, 1, 3), 
   fc.degree=c(1, 2), fc.window=c(201, 35), 
   fc.name=c("long-term", "so. osc."))

plot(co2.stl_pt, scales=list(y=list(relation="free")), 
   ylab="CO2 Concentration (ppm)", xlab="Time (years)", 
   aspect=0.25, type=c("l", "g"))

# with NAs

y <- co2
y[201:224] <- NA

y.stl <- stl3(y, l.window=13, t.window=19, s.window=35, 
   s.degree=1, sub.labels=substr(month.name, 1, 3))

plot(y.stl, ylab="CO2 Concentration (ppm)", xlab="Time (years)")
plot.seasonal(y.stl)
plot.trend(y.stl)
plot.cycle(y.stl)
plot.rembycycle(y.stl)

# if you don't want to use a time series object:
y.stl <- stl3(y, t=as.vector(time(y)), n.p=12, 
   l.window=13, t.window=19, s.window=35, s.degree=1, 
   sub.labels=substr(month.name, 1, 3))


# with an outlier
y2 <- co2
y2[200] <- 300

y2.stl <- stl3(y2, t=as.vector(time(y2)), n.p=12, 
   l.window=13, t.window=19, s.window=35, s.degree=1, 
   sub.labels=substr(month.name, 1, 3), outer=10)

plot(y2.stl, ylab="CO2 Concentration (ppm)", xlab="Time (years)")
plot.seasonal(y2.stl)
plot.trend(y2.stl)
plot.cycle(y2.stl)
plot.rembycycle(y2.stl)

# compare to R's stl

x1 <- stl3(co2, t=as.vector(time(co2)), n.p=12, 
   l.window=13, t.window=19, s.window=11, s.degree=1, 
   sub.labels=substr(month.name, 1, 3))

x2 <- stl(co2, l.window=13, t.window=19, s.window=11, s.degree=1)

# will be different due to interpolation differences
plot(seasonal(x1) - seasonal(x2))

# but not if all jump parameters are 1
x1 <- stl3(co2, t=as.vector(time(co2)), n.p=12, 
   l.window=13, t.window=19, s.window=11, s.degree=1, 
   sub.labels=substr(month.name, 1, 3), 
   s.jump=1, t.jump=1, l.jump=1)

x2 <- stl(co2, l.window=13, t.window=19, s.window=11, s.degree=1,
   s.jump=1, t.jump=1, l.jump=1)

plot(seasonal(x1) - seasonal(x2))


}
