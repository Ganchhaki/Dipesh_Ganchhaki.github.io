# ============================================================
# Case Study 2 — Publication-Quality Charts (ggplot2)
# Ad Irritation & User Frustration Study
# ============================================================

library(ggplot2)

# --- Dark theme matching portfolio aesthetic ---
theme_portfolio <- function() {
  theme_minimal(base_size = 14) +
  theme(
    plot.background = element_rect(fill = "#0f0f17", color = NA),
    panel.background = element_rect(fill = "#0f0f17", color = NA),
    panel.grid.major.y = element_line(color = "#1a1a2e", linewidth = 0.3),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    text = element_text(color = "#a0a0b8"),
    plot.title = element_text(color = "#f0f0f5", face = "bold", size = 18, margin = margin(b = 8)),
    plot.subtitle = element_text(color = "#6b6b80", size = 11, margin = margin(b = 20)),
    axis.text = element_text(color = "#a0a0b8", size = 11),
    axis.title = element_text(color = "#6b6b80", size = 11),
    axis.ticks = element_blank(),
    legend.background = element_rect(fill = "#0f0f17", color = NA),
    legend.text = element_text(color = "#a0a0b8"),
    legend.title = element_text(color = "#f0f0f5", face = "bold"),
    legend.key = element_rect(fill = "#0f0f17", color = NA),
    plot.margin = margin(30, 30, 30, 30)
  )
}

# ============================================================
# Chart 1: Mean Annoyance Rating by Ad Attribute
# ============================================================

annoyance_data <- data.frame(
  Attribute = factor(
    c("Ad Length", "Poor Quality", "Irrelevance", "High Frequency"),
    levels = c("High Frequency", "Irrelevance", "Poor Quality", "Ad Length")
  ),
  Mean = c(9.02, 8.76, 7.81, 7.2),
  SD = c(0.8, 1.1, 1.3, 1.5)
)

p1 <- ggplot(annoyance_data, aes(x = Attribute, y = Mean, fill = Mean)) +
  geom_col(width = 0.65, show.legend = FALSE) +
  geom_errorbar(aes(ymin = Mean - SD * 0.5, ymax = pmin(Mean + SD * 0.5, 10)),
                width = 0.2, color = "#a0a0b8", linewidth = 0.4) +
  geom_text(aes(label = sprintf("%.2f", Mean)),
            hjust = -0.2, color = "#f0f0f5", fontface = "bold", size = 5) +
  scale_fill_gradient(low = "#4285f4", high = "#e74c3c") +
  scale_y_continuous(limits = c(0, 10.5), breaks = seq(0, 10, 2),
                     expand = expansion(mult = c(0, 0.05))) +
  coord_flip() +
  labs(
    title = "Mean Annoyance Rating by Ad Attribute",
    subtitle = "1\u201310 Likert Scale  |  n = 59 respondents  |  Error bars = \u00b10.5 SD",
    x = NULL,
    y = "Mean Annoyance Score"
  ) +
  theme_portfolio() +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "#1a1a2e", linewidth = 0.3)
  )

ggsave("assets/chart_annoyance_bars.png", p1,
       width = 10, height = 5, dpi = 300, bg = "#0f0f17")

cat("\u2713 Chart 1 saved: assets/chart_annoyance_bars.png\n")

# ============================================================
# Chart 2: Ad Placement Irritation (Donut Chart)
# ============================================================

placement_data <- data.frame(
  Placement = factor(
    c("Mid-roll", "Pre-roll", "Post-roll", "Overlay"),
    levels = c("Mid-roll", "Pre-roll", "Post-roll", "Overlay")
  ),
  Percentage = c(44.4, 30.2, 12.8, 12.6)
)

p2 <- ggplot(placement_data, aes(x = 2, y = Percentage, fill = Placement)) +
  geom_col(width = 1, color = "#0f0f17", linewidth = 1.2) +
  coord_polar(theta = "y") +
  xlim(0.5, 2.5) +
  scale_fill_manual(values = c(
    "Mid-roll" = "#e74c3c",
    "Pre-roll" = "#f39c12",
    "Post-roll" = "#4285f4",
    "Overlay" = "#34a853"
  )) +
  geom_text(aes(label = paste0(Percentage, "%")),
            position = position_stack(vjust = 0.5),
            color = "#fff", fontface = "bold", size = 4.5) +
  labs(
    title = "Most Irritating Ad Placement",
    subtitle = "% of respondents rating each format as most annoying  |  n = 59",
    fill = "Ad Placement"
  ) +
  theme_portfolio() +
  theme(
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    legend.position = "right"
  )

ggsave("assets/chart_placement_donut.png", p2,
       width = 9, height = 6, dpi = 300, bg = "#0f0f17")

cat("\u2713 Chart 2 saved: assets/chart_placement_donut.png\n")

# ============================================================
# Chart 3: Key Metrics (Lollipop Chart)
# ============================================================

metrics_data <- data.frame(
  Metric = factor(
    c("Gave max score\nfor long ads",
      "YouTube as\nprimary platform",
      "Mid-roll rated\nmost irritating"),
    levels = c("Mid-roll rated\nmost irritating",
               "Gave max score\nfor long ads",
               "YouTube as\nprimary platform")
  ),
  Value = c(66.7, 88.1, 44.4)
)

p3 <- ggplot(metrics_data, aes(x = Metric, y = Value)) +
  geom_segment(aes(xend = Metric, y = 0, yend = Value),
               color = "#4285f4", linewidth = 2) +
  geom_point(size = 10, color = "#4285f4") +
  geom_point(size = 7, color = "#34a853") +
  geom_text(aes(label = paste0(Value, "%")),
            color = "#fff", fontface = "bold", size = 3.5) +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 25),
                     labels = function(x) paste0(x, "%")) +
  coord_flip() +
  labs(
    title = "Key Study Metrics",
    subtitle = "Critical findings at a glance  |  n = 59 respondents",
    x = NULL,
    y = NULL
  ) +
  theme_portfolio() +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "#1a1a2e", linewidth = 0.3)
  )

ggsave("assets/chart_key_metrics.png", p3,
       width = 9, height = 4.5, dpi = 300, bg = "#0f0f17")

cat("\u2713 Chart 3 saved: assets/chart_key_metrics.png\n")

# ============================================================
# Chart 4: Coping Mechanisms
# ============================================================

coping_data <- data.frame(
  Mechanism = factor(
    c("Skip immediately", "Use ad-blocker", "Pay for premium", "Mute & ignore"),
    levels = c("Mute & ignore", "Pay for premium", "Use ad-blocker", "Skip immediately")
  ),
  Percentage = c(78, 52, 35, 22)
)

p4 <- ggplot(coping_data, aes(x = Mechanism, y = Percentage, fill = Percentage)) +
  geom_col(width = 0.6, show.legend = FALSE) +
  geom_text(aes(label = paste0(Percentage, "%")),
            hjust = -0.15, color = "#f0f0f5", fontface = "bold", size = 5) +
  scale_fill_gradient(low = "#34a853", high = "#e74c3c") +
  scale_y_continuous(limits = c(0, 100), expand = expansion(mult = c(0, 0.1))) +
  coord_flip() +
  labs(
    title = "User Coping Mechanisms",
    subtitle = "How users respond to ad irritation  |  n = 59 respondents",
    x = NULL,
    y = "% of Respondents"
  ) +
  theme_portfolio() +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "#1a1a2e", linewidth = 0.3)
  )

ggsave("assets/chart_coping.png", p4,
       width = 10, height = 4.5, dpi = 300, bg = "#0f0f17")

cat("\u2713 Chart 4 saved: assets/chart_coping.png\n")
cat("\n\u2713 All 4 charts generated successfully!\n")
